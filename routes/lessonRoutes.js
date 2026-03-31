const express = require("express");
const router = express.Router();

const lesson = require("../controllers/lessonController");
const authMiddleware = require("../middleware/authMiddleware");

// add vocab to lesson
router.post("/add-vocab", authMiddleware, lesson.addVocabToLesson);

// get all words of lesson
router.get("/:lesson_id/words", authMiddleware, lesson.getLessonWords);

// get MCQ from lesson
router.get("/:lesson_id/mcq", authMiddleware, lesson.getLessonMCQ);

router.post("/enroll", authMiddleware, lesson.enrollLesson);
router.get("/my-lessons", authMiddleware, lesson.getUserLessons);
router.post("/progress", authMiddleware, lesson.updateLessonProgress);

module.exports = router;