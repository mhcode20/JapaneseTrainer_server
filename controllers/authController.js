const db = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");


const SECRET = process.env.JWT_SECRET || "mysecretkey";

// exports.register = async (req, res) => {

//   const { username, email, password } = req.body;

  
//   const hashed = await bcrypt.hash(password, 10);

//   db.query(
//     "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
//     [username, email, hashed],
//     (err) => {
//       if (err) return res.status(500).send(err);
//       res.send({status:true, message: "User registered" });
//     }
//   );
// };


exports.register = async (req, res) => {
  const { username, email, password } = req.body;

  // 1. Check if the user already exists
  db.query(
    "SELECT * FROM users WHERE username = ?",
    [username],
    async (err, results) => {
      if (err) return res.status(500).send({ status: false, message: err.message });

      // 2. If results.length > 0, the username is taken
      if (results.length > 0) {
        return res.status(400).send({ 
          status: false, 
          message: "Username already exists. Please choose another." 
        });
      }

      // 3. If not exists, proceed to hash password and insert
      try {
        const hashed = await bcrypt.hash(password, 10);

        db.query(
          "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
          [username, email, hashed],
          (insertErr) => {
            if (insertErr) return res.status(500).send({ status: false, message: insertErr.message });
            
            res.send({ status: true, message: "User registered successfully" });
          }
        );
      } catch (hashError) {
        res.status(500).send({ status: false, message: "Error processing password" });
      }
    }
  );
};

exports.login = (req, res) => {
  const { username, password } = req.body;
  console.log(username)
  db.query(
    "SELECT * FROM users WHERE username = ?",
    [username],
    async (err, result) => {
      if (result.length === 0) {
        return res.status(401).send("User not found");
      }

      const user = result[0];
      const match = await bcrypt.compare(password, user.password);

      if (!match) return res.status(401).send("Wrong password");

      const token = jwt.sign(
        { id: user.id, username: user.username },
        SECRET,
        { expiresIn: "300d" }
      );

      res.send({message:"Login Successful",status:true, token });
    }
  );
};

exports.getUser = (req, res) => {
  const userId = req.user.id; // from auth middleware

  db.query(
    "SELECT id, username, email FROM users WHERE id = ?",
    [userId],
    (err, result) => {
      if (err) return res.status(500).send(err);

      if (result.length === 0) {
        return res.status(404).send({ message: "User not found" });
      }

      res.send({
        status: true,
        user: result[0]
      });
    }
  );
};