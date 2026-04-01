const db = require("../config/db");


// ✅ 1. Add vocab to lesson
exports.addVocabToLesson = (req, res) => {
  const { lesson_id, vocab_id } = req.body;

  if (!lesson_id || !vocab_id) {
    return res.status(400).send({ message: "lesson_id and vocab_id required" });
  }

  db.query(
    "INSERT INTO lesson_vocab (lesson_id, vocab_id) VALUES (?, ?)",
    [lesson_id, vocab_id],
    (err) => {
      if (err) return res.status(500).send(err);

      res.send({
        status: true,
        message: "Vocab added to lesson"
      });
    }
  );
};


// ✅ 2. Get all words of a lesson
exports.getLessonWords = (req, res) => {
  const { lesson_id } = req.params;

  const sql = `
    SELECT v.*
    FROM lesson_vocab lv
    JOIN vocab v ON v.id = lv.vocab_id
    WHERE lv.lesson_id = ?
  `;

  db.query(sql, [lesson_id], (err, result) => {
    if (err) return res.status(500).send(err);

    res.send({
      status: true,
      data: result
    });
  });
};


// ✅ 3. Get MCQ from lesson
exports.getLessonMCQ = (req, res) => {
  const { lesson_id } = req.params;

  // Step 1: get random word from lesson
  const wordSql = `
    SELECT v.*
    FROM lesson_vocab lv
    JOIN vocab v ON v.id = lv.vocab_id
    WHERE lv.lesson_id = ?
    ORDER BY RAND()
    LIMIT 1
  `;

  db.query(wordSql, [lesson_id], (err, result) => {
    if (err) return res.status(500).send(err);

    if (result.length === 0) {
      return res.status(404).send({ message: "No vocab in this lesson" });
    }

    const word = result[0];

    // Step 2: get wrong options from same lesson
    const optionSql = `
      SELECT v.english
      FROM lesson_vocab lv
      JOIN vocab v ON v.id = lv.vocab_id
      WHERE lv.lesson_id = ? AND v.id != ?
      ORDER BY RAND()
      LIMIT 3
    `;

    db.query(optionSql, [lesson_id, word.id], (err2, wrongOptions) => {
      if (err2) return res.status(500).send(err2);

      const options = [
        word.english,
        ...wrongOptions.map(o => o.english)
      ].sort(() => Math.random() - 0.5);

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
    });
  });
};

exports.enrollLesson = (req, res) => {
  const userId = req.user.id;
  const { lesson_id } = req.body;

  db.query(
    "INSERT INTO user_lesson (user_id, lesson_id) VALUES (?, ?)",
    [userId, lesson_id],
    (err) => {
      if (err) return res.status(500).send(err);

      res.send({
        status: true,
        message: "Enrolled successfully"
      });
    }
  );
};

exports.getUserLessons = (req, res) => {
  const userId = req.user.id;

  const sql = `
    SELECT l.*, ul.status, ul.progress
    FROM user_lesson ul
    JOIN lessons l ON l.id = ul.lesson_id
    WHERE ul.user_id = ?
  `;

  db.query(sql, [userId], (err, result) => {
    if (err) return res.status(500).send(err);

    res.send({
      status: true,
      data: result
    });
  });
};

exports.getAllLessons = (req, res) => {
  const userId = req.user.id;

  const sql = `
    SELECT * from lessons;
  `;

  db.query(sql, [userId], (err, result) => {
    if (err) return res.status(500).send(err);

    res.send({
      status: true,
      data: result
    });
  });
};



exports.updateLessonProgress = (req, res) => {
  const userId = req.user.id;
  const { lesson_id, progress } = req.body;

  const status = progress >= 100 ? "completed" : "enrolled";

  db.query(
    `UPDATE user_lesson 
     SET progress = ?, status = ? 
     WHERE user_id = ? AND lesson_id = ?`,
    [progress, status, userId, lesson_id],
    (err) => {
      if (err) return res.status(500).send(err);

      res.send({
        status: true,
        message: "Progress updated"
      });
    }
  );
};

exports.getLessonWordCount = (req, res) => {
  const { lesson_id } = req.params;

  db.query(
    "SELECT COUNT(*) AS total_words FROM lesson_vocab WHERE lesson_id = ?",
    [lesson_id],
    (err, result) => {
      if (err) return res.status(500).send(err);

      res.send({
        status: true,
        lesson_id,
        total_words: result[0].total_words
      });
    }
  );
};

exports.getLessonDetails = (req, res) => {
  const { lesson_id } = req.params;

  const sql = `
    SELECT 
      l.*,
      COUNT(lv.vocab_id) AS total_words
    FROM lessons l
    LEFT JOIN lesson_vocab lv ON l.id = lv.lesson_id
    WHERE l.id = ?
    GROUP BY l.id
  `;

  db.query(sql, [lesson_id], (err, result) => {
    if (err) return res.status(500).send(err);

    res.send({
      status: true,
      data: result[0]
    });
  });
};

exports.getAttemptedWords = (req, res) => {
  const userId = req.user.id;
  const { lesson_id } = req.params;

  const sql = `
    SELECT COUNT(DISTINCT s.vocab_id) AS attempted_words
    FROM user_word_stats s
    JOIN lesson_vocab lv ON lv.vocab_id = s.vocab_id
    WHERE s.user_id = ?
    AND lv.lesson_id = ?
  `;

  db.query(sql, [userId, lesson_id], (err, result) => {
    if (err) return res.status(500).send(err);

    res.send({
      status: true,
      lesson_id,
      attempted_words: result[0].attempted_words
    });
  });
};

exports.getLessonProgress = (req, res) => {
  const userId = req.user.id;
  const { lesson_id } = req.params;

  const sql = `
    SELECT 
      COUNT(DISTINCT lv.vocab_id) AS total_words,
      COUNT(DISTINCT s.vocab_id) AS attempted_words
    FROM lesson_vocab lv
    LEFT JOIN user_word_stats s 
      ON s.vocab_id = lv.vocab_id AND s.user_id = ?
    WHERE lv.lesson_id = ?
  `;

  db.query(sql, [userId, lesson_id], (err, result) => {
    if (err) return res.status(500).send(err);

    const total = result[0].total_words;
    const attempted = result[0].attempted_words;

    const progress = total > 0 ? Math.round((attempted / total) * 100) : 0;

    res.send({
      status: true,
      lesson_id,
      total_words: total,
      attempted_words: attempted,
      progress
    });
  });
};