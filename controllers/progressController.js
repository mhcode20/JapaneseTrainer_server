const db = require("../config/db");

// Update stats when user answers a question
exports.updateProgress = (req, res) => {
  const userId = req.user.id; // from auth middleware
  const { vocab_id, isCorrect } = req.body;

  if (!vocab_id || typeof isCorrect === "undefined") {
    return res.status(400).send("Missing data");
  }

  // Check if record exists
  db.query(
    "SELECT * FROM user_word_stats WHERE user_id = ? AND vocab_id = ?",
    [userId, vocab_id],
    (err, result) => {
      if (err) return res.status(500).send(err);

      if (result.length === 0) {
        // 🆕 First time attempt
        const attempts = 1;
        const correct = isCorrect ? 1 : 0;
        const wrong = isCorrect ? 0 : 1;
        const streak = isCorrect ? 1 : 0;

        db.query(
          `INSERT INTO user_word_stats 
           (user_id, vocab_id, attempts, correct, wrong, streak, last_result)
           VALUES (?, ?, ?, ?, ?, ?, ?)`,
          [
            userId,
            vocab_id,
            attempts,
            correct,
            wrong,
            streak,
            isCorrect ? "correct" : "wrong"
          ],
          (err2) => {
            if (err2) return res.status(500).send(err2);
            res.send({ message: "Progress created" });
          }
        );

      } else {
        // 🔄 Update existing
        const row = result[0];

        let attempts = row.attempts + 1;
        let correct = row.correct;
        let wrong = row.wrong;
        let streak = row.streak;

        if (isCorrect) {
          correct += 1;
          streak = row.last_result === "correct" ? streak + 1 : 1;
        } else {
          wrong += 1;
          streak = 0;
        }

        db.query(
          `UPDATE user_word_stats 
           SET attempts=?, correct=?, wrong=?, streak=?, last_result=? 
           WHERE user_id=? AND vocab_id=?`,
          [
            attempts,
            correct,
            wrong,
            streak,
            isCorrect ? "correct" : "wrong",
            userId,
            vocab_id
          ],
          (err3) => {
            if (err3) return res.status(500).send(err3);

            res.send({
              message: "Progress updated",
              attempts,
              correct,
              wrong,
              streak
            });
          }
        );
      }
    }
  );
};


exports.getVocabProgress = (req, res) => {
  const userId = req.user.id;
  const { vocab_id } = req.params; // Get ID from URL parameter

  if (!vocab_id) {
    return res.status(400).send("Vocabulary ID is required");
  }

  const sql = `
    SELECT 
      attempts, 
      correct, 
      wrong, 
      streak, 
      last_result,
      updated_at
    FROM user_word_stats 
    WHERE user_id = ? AND vocab_id = ?
  `;

  db.query(sql, [userId, vocab_id], (err, result) => {
    if (err) {
      return res.status(500).send(err);
    }

    if (result.length === 0) {
      // Return a "neutral" state if the user hasn't practiced this word yet
      return res.status(200).json({
        message: "No progress recorded for this word",
        stats: {
          attempts: 0,
          correct: 0,
          wrong: 0,
          streak: 0,
          last_result: null
        }
      });
    }

    res.status(200).json({
      vocab_id,
      stats: result[0]
    });
  });
};

exports.getWeakWords = (req, res) => {
  const userId = req.user.id;

  const sql = `
    SELECT 
      v.id,
      v.hiragana,
      v.kanji,
      v.english,
      v.bangla,
      s.attempts,
      s.correct,
      s.wrong,
      s.streak,
      (s.wrong / NULLIF(s.attempts, 0)) * 100 AS error_rate
    FROM user_word_stats s
    JOIN vocab v ON v.id = s.vocab_id
    WHERE s.user_id = ?
    ORDER BY error_rate DESC, s.wrong DESC
    LIMIT 10
  `;

  db.query(sql, [userId], (err, result) => {
    if (err) return res.status(500).send(err);

    res.send({
      status: true,
      data: result
    });
  });
};


/*******************************************************************************
 * *
 * Smart Question                                       *
 * *
 *******************************************************************************/


exports.getSmartQuestion = (req, res) => {
  const userId = req.user.id;

  // ⏳ Cooldown (10 minutes)
  const COOLDOWN = "10 MINUTE";

  // Step 1: Try weak words (not recently seen)
  const weakSql = `
    SELECT v.*
    FROM user_word_stats s
    JOIN vocab v ON v.id = s.vocab_id
    WHERE s.user_id = ?
    AND (s.updated_at IS NULL OR s.updated_at < NOW() - INTERVAL ${COOLDOWN})
    ORDER BY (s.wrong - s.correct) DESC, s.streak ASC
    LIMIT 1
  `;

  db.query(weakSql, [userId], (err, weakResult) => {
    if (err) return res.status(500).send(err);

    if (weakResult.length > 0) {
      return sendMCQ(res, weakResult[0], userId);
    }

    // Step 2: New words (never attempted)
    const newSql = `
      SELECT *
      FROM vocab
      WHERE id NOT IN (
        SELECT vocab_id FROM user_word_stats WHERE user_id = ?
      )
      ORDER BY RAND()
      LIMIT 1
    `;

    db.query(newSql, [userId], (err2, newResult) => {
      if (err2) return res.status(500).send(err2);

      if (newResult.length > 0) {
        return sendMCQ(res, newResult[0], userId);
      }

      // Step 3: Random but avoid recently seen
      const randomSql = `
        SELECT *
        FROM vocab
        WHERE id NOT IN (
          SELECT vocab_id 
          FROM user_word_stats 
          WHERE user_id = ?
          AND updated_at > NOW() - INTERVAL ${COOLDOWN}
        )
        ORDER BY RAND()
        LIMIT 1
      `;

      db.query(randomSql, [userId], (err3, randomResult) => {
        if (err3) return res.status(500).send(err3);

        if (randomResult.length > 0) {
          return sendMCQ(res, randomResult[0], userId);
        }

        // Step 4: Final fallback (if everything filtered out)
        db.query(
          "SELECT * FROM vocab ORDER BY RAND() LIMIT 1",
          (err4, fallback) => {
            if (err4) return res.status(500).send(err4);

            return sendMCQ(res, fallback[0], userId);
          }
        );
      });
    });
  });
};

function sendMCQ(res, word, userId) {
  // ✅ Update updated_at (insert if not exists)
  db.query(
    `
    INSERT INTO user_word_stats (user_id, vocab_id, updated_at)
    VALUES (?, ?, NOW())
    ON DUPLICATE KEY UPDATE updated_at = NOW()
    `,
    [userId, word.id]
  );

  // ✅ Get wrong options
  db.query(
    "SELECT english FROM vocab WHERE id != ? ORDER BY RAND() LIMIT 3",
    [word.id],
    (err, wrongOptions) => {
      if (err) return res.status(500).send(err);

      const options = [
        word.english,
        ...wrongOptions.map(w => w.english)
      ].sort(() => Math.random() - 0.5);

      // ✅ Final response (your format)
      res.send({
        id: word.id,
        romaji: word.romaji,
        kanji: word.kanji,
        bangla: word.bangla,
        uccharon: word.uccharon,
        question: word.hiragana,
        correct: word.english,
        options
      });
    }
  );
}






// ###################################################################
// ###################################################################
// ###################################################################

exports.getProgressSummary = (req, res) => {
  const userId = req.user.id;

  const sql = `
    SELECT 
      COUNT(*) AS total_vocab,
      COALESCE(SUM(attempts), 0) AS total_attempts,
      COALESCE(SUM(correct), 0) AS total_correct,
      COALESCE(SUM(wrong), 0) AS total_wrong,

      CASE 
        WHEN SUM(attempts) > 0 
        THEN (SUM(correct) * 100.0 / NULLIF(SUM(attempts), 0))
        ELSE 0
      END AS accuracy,

      MAX(streak) AS best_streak,
      SUM(CASE WHEN last_result = 'correct' THEN 1 ELSE 0 END) AS total_correct_sessions,
      SUM(CASE WHEN last_result = 'wrong' THEN 1 ELSE 0 END) AS total_wrong_sessions

    FROM user_word_stats
    WHERE user_id = ?;
  `;

  db.query(sql, [userId], (err, result) => {
    if (err) return res.status(500).send(err);

    const data = result[0];

    res.json({
      success: true,
      data: {
        total_vocab: data.total_vocab,
        total_attempts: data.total_attempts,
        total_correct: data.total_correct,
        total_wrong: data.total_wrong,
        accuracy: Number(parseFloat(data.accuracy || 0).toFixed(2)),
        best_streak: data.best_streak,
        correct_sessions: data.total_correct_sessions,
        wrong_sessions: data.total_wrong_sessions
      }
    });
    // res.json({tes:"jsldkjf"})
  });
};