const express = require("express");
const router = express.Router();
const vocab = require("../controllers/vocabController");
const authMiddleware = require("../middleware/authMiddleware");

router.get("/", authMiddleware, vocab.getAll);
router.post("/insert", authMiddleware, vocab.insertBulk);
router.get("/getMCQ", authMiddleware, vocab.getMCQ);

module.exports = router;