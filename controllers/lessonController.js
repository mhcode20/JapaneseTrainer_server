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