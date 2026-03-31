const db = require("../config/db");

exports.getAll = (req, res) => {
    db.query("SELECT * FROM vocab", (err, result) => {
        if (err) return res.status(500).send(err);
        console.log(result[0])
        res.send(result);
    });
};

exports.getOne = (req, res) => {
    db.query("SELECT * FROM vocab", (err, result) => {
        if (err) return res.status(500).send(err);
        res.send(result);
    });
};


exports.getMCQ = (req, res) => {
    // Step 1: get one random word
    db.query("SELECT * FROM vocab ORDER BY RAND() LIMIT 1", (err, result) => {
        if (err) return res.status(500).send(err);

        const word = result[0];

        // Step 2: get 3 random wrong answers
        db.query(
            "SELECT english FROM vocab WHERE id != ? ORDER BY RAND() LIMIT 3",
            [word.id],
            (err2, wrongResults) => {
                if (err2) return res.status(500).send(err2);

                const options = [
                    word.english,
                    ...wrongResults.map(r => r.english)
                ];

                // Step 3: shuffle options
                const shuffled = options.sort(() => Math.random() - 0.5);

                // Step 4: send response
                res.json({
                    id: word.id,
                    romaji: word.romaji,
                    kanji: word.kanji,
                    bangla: word.bangla,
                    question: word.hiragana,
                    correct: word.english,
                    uccharon: word.uccharon,
                    options: shuffled
                });
            }
        );
    });
};

exports.getReverseMCQ = (req, res) => {
    // Step 1: get one random word
    db.query("SELECT * FROM vocab ORDER BY RAND() LIMIT 1", (err, result) => {
        if (err) return res.status(500).send(err);

        const word = result[0];

        // Step 2: get 3 wrong Japanese options
        db.query(
            "SELECT hiragana FROM vocab WHERE id != ? ORDER BY RAND() LIMIT 3",
            [word.id],
            (err2, wrongResults) => {
                if (err2) return res.status(500).send(err2);

                const options = [
                    word.hiragana,
                    ...wrongResults.map(r => r.hiragana)
                ];

                // Step 3: shuffle
                const shuffled = options.sort(() => Math.random() - 0.5);

                // Step 4: send response
                res.json({
                    id: word.id,
                    kanji: word.kanji,
                    bangla: word.bangla,
                    question: word.english,
                    correct: word.hiragana,
                    uccharon: word.uccharon,
                    options: shuffled
                });
            }
        );
    });
};

exports.insertBulk = (req, res) => {
    const values = req.body;

    const sql = `
    INSERT INTO vocab (hiragana, kanji, english, bangla, romaji)
    VALUES ?
  `;

    db.query(sql, [values], (err, result) => {
        if (err) return res.status(500).send(err);
        res.send({ message: "Inserted" });
    });
};


