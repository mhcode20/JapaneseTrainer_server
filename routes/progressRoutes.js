const express = require("express");
const router = express.Router();

const progress = require("../controllers/progressController");
const authMiddleware = require("../middleware/authMiddleware");

router.post("/update", authMiddleware, progress.updateProgress);
router.get("/:vocab_id", authMiddleware, progress.getVocabProgress);

router.get("/weak", authMiddleware, progress.getWeakWords);
router.get("/weak", authMiddleware, progress.getWeakWords);
router.get("/smart", authMiddleware, progress.getSmartQuestion);

module.exports = router;