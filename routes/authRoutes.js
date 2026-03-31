const express = require("express");
const router = express.Router();
const auth = require("../controllers/authController");
const multer = require('multer');
const upload = multer(); // No storage needed for text fields
const authMiddleware = require("../middleware/authMiddleware");


router.post("/register", auth.register);
router.post("/login",upload.none(), auth.login);
router.get("/getUser",authMiddleware ,auth.getUser);

module.exports = router;