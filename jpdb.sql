-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 07, 2026 at 05:05 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `jpdb`
--

-- --------------------------------------------------------

--
-- Table structure for table `lessons`
--

CREATE TABLE `lessons` (
  `id` int(11) NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `icon` varchar(10) DEFAULT 'A',
  `color` varchar(10) DEFAULT '#ffff00',
  `difficulty` varchar(10) NOT NULL DEFAULT 'Easy'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lessons`
--

INSERT INTO `lessons` (`id`, `title`, `description`, `created_at`, `icon`, `color`, `difficulty`) VALUES
(1, 'Test Lesson 1', 'this is test 1.', '2026-03-31 18:42:48', 'A', 'green', 'Easy'),
(2, 'test lesson 2 ', 'do not enrol', '2026-04-02 17:04:08', '🏓', 'pink', 'Easy');

-- --------------------------------------------------------

--
-- Table structure for table `lesson_vocab`
--

CREATE TABLE `lesson_vocab` (
  `id` int(11) NOT NULL,
  `lesson_id` int(11) DEFAULT NULL,
  `vocab_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `lesson_vocab`
--

INSERT INTO `lesson_vocab` (`id`, `lesson_id`, `vocab_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 1, 3),
(4, 1, 4);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password` varchar(255) NOT NULL,
  `img` varchar(100) NOT NULL DEFAULT 'test',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `img`, `created_at`, `updated_at`) VALUES
(14, 'dslkfj', 'mhrridoy0c@gkdf.com', '$2b$10$UzX6qz1W/8lIx/QcLm4j0OYL58QQEp9H5Mv8ukNE4LhqeeNVRQzgK', 'test', '2026-03-26 13:45:54', '2026-03-26 13:45:54'),
(16, 'dslkfj', 'mhrroy0c@gkdf.com', '$2b$10$4FAwZ6TiH62w6VoPYTNrJOnCSSmu2ASeiwcqx1BGLjxpCLJIVW3.K', 'test', '2026-03-26 13:49:13', '2026-03-26 13:49:13'),
(17, 'hridoy', 'hridoy@gmail.com', '$2b$10$CS0Tl29k4NJdH00bgmQEGuIeERuOrZA.anHhByDbb2PRYNjaTIOJm', 'test', '2026-03-26 13:51:21', '2026-03-26 13:51:21'),
(18, 'hridoy0x', 'hridoy0x@gmail.com', '$2b$10$G91omG4xb2dwNbqoH8TY6u7ouxoG8oMNXz3oU71d3lNcnYygs/VvC', 'test', '2026-03-27 10:57:22', '2026-03-27 10:57:22');

-- --------------------------------------------------------

--
-- Table structure for table `user_lesson`
--

CREATE TABLE `user_lesson` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `lesson_id` int(11) NOT NULL,
  `status` enum('enrolled','completed') DEFAULT 'enrolled',
  `progress` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_lesson`
--

INSERT INTO `user_lesson` (`id`, `user_id`, `lesson_id`, `status`, `progress`, `created_at`, `updated_at`) VALUES
(1, 17, 1, 'enrolled', 0, '2026-04-01 18:46:27', '2026-04-01 18:46:27'),
(11, 17, 2, 'enrolled', 0, '2026-04-05 10:22:32', '2026-04-05 10:22:32');

-- --------------------------------------------------------

--
-- Table structure for table `user_word_stats`
--

CREATE TABLE `user_word_stats` (
  `id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `vocab_id` int(11) DEFAULT NULL,
  `attempts` int(11) DEFAULT 0,
  `correct` int(11) DEFAULT 0,
  `wrong` int(11) DEFAULT 0,
  `streak` int(11) DEFAULT 0,
  `last_result` enum('correct','wrong') DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_word_stats`
--

INSERT INTO `user_word_stats` (`id`, `user_id`, `vocab_id`, `attempts`, `correct`, `wrong`, `streak`, `last_result`, `created_at`, `updated_at`) VALUES
(6, 17, 16, 9, 4, 5, 1, 'correct', '2026-03-28 08:50:01', '2026-04-06 16:16:59'),
(7, 17, 13, 7, 5, 2, 3, 'correct', '2026-03-28 08:50:16', '2026-03-30 15:10:51'),
(8, 17, 8, 7, 5, 2, 2, 'correct', '2026-03-28 08:50:23', '2026-03-30 15:07:15'),
(9, 17, 5, 7, 5, 2, 1, 'correct', '2026-03-28 08:50:28', '2026-03-30 14:28:53'),
(10, 17, 2, 8, 5, 3, 0, 'wrong', '2026-03-28 09:00:29', '2026-04-06 16:22:55'),
(11, 17, 18, 5, 5, 0, 5, 'correct', '2026-03-28 09:00:37', '2026-03-29 16:12:46'),
(12, 17, 19, 4, 4, 0, 4, 'correct', '2026-03-28 09:00:59', '2026-03-29 16:14:41'),
(13, 17, 17, 5, 4, 1, 1, 'correct', '2026-03-28 09:01:05', '2026-03-29 16:11:52'),
(14, 17, 12, 14, 11, 3, 9, 'correct', '2026-03-28 09:05:07', '2026-03-30 14:59:16'),
(15, 17, 15, 4, 3, 1, 2, 'correct', '2026-03-28 09:12:07', '2026-03-30 14:30:24'),
(16, 17, 1, 8, 7, 1, 0, 'wrong', '2026-03-28 09:12:08', '2026-04-06 16:04:11'),
(17, 17, 9, 5, 4, 1, 3, 'correct', '2026-03-28 09:12:09', '2026-03-30 14:29:56'),
(18, 17, 11, 3, 3, 0, 3, 'correct', '2026-03-28 09:12:12', '2026-03-30 14:29:59'),
(19, 17, 4, 15, 6, 9, 1, 'correct', '2026-03-28 09:12:17', '2026-04-06 16:16:44'),
(20, 17, 14, 14, 6, 8, 1, 'correct', '2026-03-28 09:12:18', '2026-04-06 16:16:49'),
(21, 17, 47, 4, 3, 1, 2, 'correct', '2026-03-28 12:10:14', '2026-03-30 14:28:41'),
(22, 17, 52, 4, 3, 1, 2, 'correct', '2026-03-28 12:10:15', '2026-03-30 14:28:04'),
(23, 17, 56, 4, 4, 0, 4, 'correct', '2026-03-28 12:10:17', '2026-03-29 16:12:34'),
(24, 17, 50, 8, 5, 3, 3, 'correct', '2026-03-28 12:10:19', '2026-04-06 16:17:45'),
(25, 17, 41, 4, 3, 1, 1, 'correct', '2026-03-28 12:14:09', '2026-04-06 16:23:46'),
(26, 17, 32, 3, 3, 0, 3, 'correct', '2026-03-28 12:24:58', '2026-03-29 16:12:20'),
(27, 17, 57, 4, 4, 0, 4, 'correct', '2026-03-28 12:26:20', '2026-03-29 16:12:36'),
(28, 17, 37, 3, 3, 0, 3, 'correct', '2026-03-28 12:26:42', '2026-03-29 16:12:27'),
(29, 17, 38, 3, 3, 0, 3, 'correct', '2026-03-28 12:26:55', '2026-03-30 14:29:51'),
(30, 17, 42, 3, 3, 0, 3, 'correct', '2026-03-28 12:27:04', '2026-03-30 14:30:06'),
(31, 17, 53, 4, 3, 1, 3, 'correct', '2026-03-28 17:19:36', '2026-04-06 16:17:19'),
(32, 17, 23, 4, 3, 1, 2, 'correct', '2026-03-28 17:19:59', '2026-03-30 14:28:00'),
(33, 17, 28, 3, 3, 0, 3, 'correct', '2026-03-28 17:20:25', '2026-03-29 16:12:29'),
(34, 17, 29, 4, 4, 0, 4, 'correct', '2026-03-28 17:20:34', '2026-03-29 16:12:39'),
(35, 17, 30, 4, 3, 1, 3, 'correct', '2026-03-29 05:38:09', '2026-03-30 14:28:49'),
(36, 17, 45, 9, 5, 4, 3, 'correct', '2026-03-29 05:40:43', '2026-04-06 16:17:46'),
(37, 17, 6, 3, 3, 0, 3, 'correct', '2026-03-29 05:40:54', '2026-03-30 14:30:14'),
(38, 17, 35, 3, 3, 0, 3, 'correct', '2026-03-29 05:41:04', '2026-03-30 14:30:10'),
(39, 17, 24, 3, 3, 0, 3, 'correct', '2026-03-29 05:41:22', '2026-03-29 16:12:07'),
(40, 17, 3, 8, 7, 1, 0, 'wrong', '2026-03-29 05:41:52', '2026-04-06 16:04:08'),
(41, 17, 39, 3, 3, 0, 3, 'correct', '2026-03-29 05:42:43', '2026-03-30 14:29:34'),
(42, 17, 33, 3, 3, 0, 3, 'correct', '2026-03-29 05:47:21', '2026-03-30 14:29:30'),
(43, 17, 10, 3, 3, 0, 3, 'correct', '2026-03-29 05:48:24', '2026-03-30 14:29:25'),
(44, 17, 51, 3, 3, 0, 3, 'correct', '2026-03-29 08:11:03', '2026-03-30 14:29:21'),
(45, 17, 55, 3, 3, 0, 3, 'correct', '2026-03-29 08:11:11', '2026-03-30 14:29:18'),
(46, 17, 25, 5, 3, 2, 2, 'correct', '2026-03-29 08:11:29', '2026-04-06 16:17:13'),
(47, 17, 40, 4, 3, 1, 3, 'correct', '2026-03-29 15:28:00', '2026-04-06 16:17:27'),
(90, 17, 43, 6, 4, 2, 1, 'correct', '2026-03-29 16:12:47', '2026-04-06 16:06:44'),
(91, 17, 7, 2, 2, 0, 2, 'correct', '2026-03-29 16:12:54', '2026-03-30 14:27:57'),
(92, 17, 54, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:02', '2026-03-30 14:27:52'),
(93, 17, 48, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:05', '2026-03-30 14:27:49'),
(94, 17, 49, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:11', '2026-03-30 14:27:46'),
(95, 17, 20, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:15', '2026-03-30 14:27:40'),
(96, 17, 34, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:18', '2026-03-30 14:27:32'),
(97, 17, 46, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:22', '2026-03-30 14:26:02'),
(98, 17, 22, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:34', '2026-03-30 14:25:47'),
(99, 17, 31, 4, 3, 1, 1, 'correct', '2026-03-29 16:13:52', '2026-04-06 16:24:00'),
(100, 17, 27, 2, 2, 0, 2, 'correct', '2026-03-29 16:13:56', '2026-03-30 14:25:55'),
(101, 17, 21, 3, 3, 0, 3, 'correct', '2026-03-29 16:14:01', '2026-03-30 15:07:36'),
(102, 17, 26, 4, 2, 2, 0, 'wrong', '2026-03-29 16:14:04', '2026-04-06 16:15:24'),
(103, 17, 44, 5, 4, 1, 4, 'correct', '2026-03-29 16:14:10', '2026-03-30 14:58:09'),
(104, 17, 36, 3, 3, 0, 3, 'correct', '2026-03-29 16:14:23', '2026-03-30 15:07:21');

-- --------------------------------------------------------

--
-- Table structure for table `vocab`
--

CREATE TABLE `vocab` (
  `id` int(11) NOT NULL,
  `hiragana` varchar(50) DEFAULT NULL,
  `kanji` varchar(50) DEFAULT NULL,
  `english` varchar(100) DEFAULT NULL,
  `bangla` varchar(100) DEFAULT NULL,
  `romaji` varchar(50) DEFAULT NULL,
  `uccharon` varchar(100) NOT NULL DEFAULT '...'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `vocab`
--

INSERT INTO `vocab` (`id`, `hiragana`, `kanji`, `english`, `bangla`, `romaji`, `uccharon`) VALUES
(1, 'いま', '今', 'now', 'এখন', 'ima', '...'),
(2, 'きょう', '今日', 'today', 'আজ', 'kyou', '...'),
(3, 'あした', '明日', 'tomorrow', 'আগামীকাল', 'ashita', '...'),
(4, 'きのう', '昨日', 'yesterday', 'গতকাল', 'kinou', '...'),
(5, 'まいにち', '毎日', 'every day', 'প্রতিদিন', 'mainichi', '...'),
(6, 'まいあさ', '毎朝', 'every morning', 'প্রতিদিন সকাল', 'maiasa', '...'),
(7, 'まいばん', '毎晩', 'every night', 'প্রতিদিন রাত', 'maiban', '...'),
(8, 'まいしゅう', '毎週', 'every week', 'প্রতি সপ্তাহে', 'maishuu', '...'),
(9, 'なんじ', '何時', 'what time', 'কয়টা বাজে', 'nanji', '...'),
(10, 'なんぷん', '何分', 'what minute', 'কয় মিনিট', 'nanpun', '...'),
(11, 'ごぜん', '午前', 'AM', 'সকাল (AM)', 'gozen', '...'),
(12, 'ごご', '午後', 'PM', 'বিকাল (PM)', 'gogo', '...'),
(13, 'はん', '半', 'half', 'অর্ধেক', 'han', '...'),
(14, 'いきます', '行きます', 'go', 'যাওয়া', 'ikimasu', '...'),
(15, 'きます', '来ます', 'come', 'আসা', 'kimasu', '...'),
(16, 'かえります', '帰ります', 'return', 'ফিরে যাওয়া', 'kaerimasu', '...'),
(17, 'がっこう', '学校', 'school', 'স্কুল', 'gakkou', '...'),
(18, 'かいしゃ', '会社', 'company', 'কোম্পানি', 'kaisha', '...'),
(19, 'うち', '家', 'home', 'বাড়ি', 'uchi', '...'),
(20, 'でんしゃ', '電車', 'train', 'ট্রেন', 'densha', '...'),
(21, 'ハンサム', 'ハンサム (ナ形)', 'Handsome', 'সুদর্শন', 'hansamu', 'হানসাম'),
(22, 'きれい', 'きれい (ナ形)', 'Beautiful, clean', 'সুন্দর, পরিষ্কার', 'kirei', 'কিরে'),
(23, 'しずか', '静か (ナ形)', 'Quiet', 'শান্ত', 'shizuka', 'শিজুকা'),
(24, 'にぎやか', 'にぎやか (ナ形)', 'Lively', 'প্রাণবন্ত', 'nigiyaka', 'নিগিয়াকা'),
(25, 'ゆうめい', '有名 (ナ形)', 'Famous', 'বিখ্যাত', 'yuumei', 'ইউমেই'),
(26, 'しんせつ', '親切 (ナ形)', 'Kind', 'দয়ালু', 'shinsetsu', 'শিনসেত্সু'),
(27, 'げんき', '元気 (ナ形)', 'Healthy, sound, cheerful', 'স্বাস্থ্য, শব্দ, আনন্দিত', 'genki', 'গেনকি'),
(28, 'ひま', '暇 (ナ形)', 'Free (time)', 'অবসর সময়', 'hima', 'হিমা'),
(29, 'べんり', '便利 (ナ形)', 'Convenient', 'সুবিধাজনক', 'benri', 'বেনরি'),
(30, 'すてき', '素敵 (ナ形)', 'Fine, nice, wonderful', 'সুন্দর, চমৎকার', 'suteki', 'সুতেকি'),
(31, 'おおきい', '大きい', 'Big, large', 'বড়', 'ookii', 'ওওকই'),
(32, 'ちいさい', '小さい', 'Small, little', 'ছোট', 'chiisai', 'চিসাই'),
(33, 'あたらしい', '新しい', 'New', 'নতুন', 'atarashii', 'আতারাসিই'),
(34, 'ふるい', '古い', 'Old (not of age)', 'পুরাতন (বয়স নয়)', 'furui', 'ফুরই'),
(35, 'いい (よい)', 'いい (よい)', 'Good', 'ভালো', 'ii (yoi)', 'ইই (ইয়োই)'),
(36, 'わるい', '悪い', 'Bad', 'খারাপ', 'warui', 'ওয়ারু'),
(37, 'あつい', '暑い', 'Hot', 'গরমে', 'atsui', 'আৎসু'),
(38, 'さむい', '寒い', 'Cold (referring to temperature)', 'ঠান্ডা (তাপমাত্রা)', 'samui', 'সামুই'),
(39, 'つめたい', '冷たい', 'Cold (referring to touch)', 'ঠান্ডা (স্পর্শ করে , ফ্রিজিং)', 'tsumetai', 'ৎসমেতাই'),
(40, 'むずかしい', '難しい', 'Difficult', 'কঠিন', 'muzukashii', 'মুজুকাসি'),
(41, 'やさしい', '易しい', 'Easy', 'সহজ', 'yasashii', 'ইয়াসাসিই'),
(42, 'たかい', '高い', 'Expensive, tall, high', 'ব্যয়বহুল, লম্বা, উঁচু', 'takai', 'তাকাই'),
(43, 'やすい', '安い', 'Inexpensive', 'মিতব্যয়ী, সস্তা', 'yasui', 'ইয়াসুই'),
(44, 'ひくい', '低い', 'Low', 'কম, নিম্ন', 'hikui', 'হিকুই'),
(45, 'おもしろい', '面白い', 'Interesting', 'মজাদার', 'omoshiroi', 'ওমোসিরোই'),
(46, 'おいしい', '美味しい', 'Delicious, tasty', 'সুস্বাদু', 'oishii', 'ওয়েিসি'),
(47, 'いそがしい', '忙しい', 'Busy', 'ব্যস্ত', 'isogashii', 'ইসেগাসি'),
(48, 'たのしい', '楽しい', 'Enjoyable', 'উপভোগ্য', 'tanoshii', 'তানোসি'),
(49, 'しろい', '白い', 'White', 'সাদা', 'shiroi', 'শিরোই'),
(50, 'くろい', '黒い', 'Black', 'কালো', 'kuroi', 'কুরোই'),
(51, 'あかい', '赤い', 'Red', 'লাল', 'akai', 'আকাই'),
(52, 'あおい', '青い', 'Blue', 'নীল', 'aoi', 'আওই'),
(53, 'さくら', '桜', 'Cherry (blossom)', 'চেরি (ফুল ফোটা)', 'sakura', 'সাকুরা'),
(54, 'やま', '山', 'Mountain', 'পর্বত', 'yama', 'ইয়ামা'),
(55, 'まち', '町', 'Town, city', 'শহর', 'machi', 'মাচি'),
(56, 'たべもの', '食べ物', 'Food', 'খাদ্য', 'tabemono', 'তাবেমোনো'),
(57, 'くるま', '車', 'Car', 'গাড়ি', 'kuruma', 'কুরুমা'),
(58, 'わかります', '分かります', 'Understand', 'বুঝতে পারা', 'wakarimasu', 'ওয়াকারিামাস'),
(59, 'あります', NULL, 'Have (thing)', 'আছে (বস্তু)', 'arimasu', 'আরিমাস'),
(60, 'すき [な]', '好き [な]', 'Like', 'পছন্দ', 'suki [na]', 'সুকি না'),
(61, 'きらい [な]', '嫌い [な]', 'Dislike', 'অপছন্দ', 'kirai [na]', 'কিরাই না'),
(62, 'じょうず [な]', '上手 [な]', 'Good at', 'দক্ষ', 'jouzu [na]', 'জৌজু না'),
(63, 'へた [な]', '下手 [な]', 'Poor at', 'অদক্ষ', 'heta [na]', 'হেতা না'),
(64, 'りょうり', '料理', 'Dish (cooked food)', 'ডিশ (রান্না করা খাবার)', 'ryouri', 'রিয়োরি'),
(65, 'のみもの', '飲み物', 'Drinks', 'পানীয়', 'nomimono', 'নোমিমোনো'),
(66, 'スポーツ', NULL, 'Sport', 'খেলাধুলা', 'supo-tsu', 'সুপোৎসু'),
(67, 'やきゅう', '野球', 'baseball', 'বেসবল', 'yakyuu', 'ইয়াকিয়ু'),
(68, 'ダンス', NULL, 'dance', 'নাচ, নৃত্য', 'dansu', 'দানসু'),
(69, 'おんがく', '音楽', 'Music', 'মিউজিক, সংগীত', 'ongaku', 'উনগাকু'),
(70, 'うた', '歌', 'Song', 'গান', 'uta', 'উতা'),
(71, 'クラシック', NULL, 'Clasial music', 'ক্লাসিক্যাল সংগীত', 'kurashikku', 'কুরাশিক্কু'),
(72, 'ジャズ', NULL, 'Jazz', 'জ্যাজ', 'jazu', 'জাজু'),
(73, 'コンサート', NULL, 'Concert', 'কনসার্ট', 'konsa-to', 'কোনসাতো'),
(74, 'カラオケ', NULL, 'Karaoke', 'কারাওকে', 'karaoke', 'কারাওকে'),
(75, 'かぶき', '歌舞伎', 'Kabuki (traditional Japanese music)', 'কাবুকি', 'kabuki', 'কাবুকি'),
(76, 'え', '絵', 'Picture, drawing', 'ছবি, আঁকা', 'e', 'এ'),
(77, 'じ', '字', 'Letter, character', 'বর্ণ', 'ji', 'জি'),
(78, 'かんじ', '漢字', 'Chinese characters', 'চীনা বর্ণমালা', 'kanji', 'কানজি'),
(79, 'ひらがな', NULL, 'Hiragana script', 'হিরাগানা', 'hiragana', 'হিরাগানা'),
(80, 'かたかな', NULL, 'Katakana script', 'কাতাকানা', 'katakana', 'কাতাকানা'),
(81, 'ローマじ', NULL, 'The Roman alphabet', 'রোমান বর্ণমালা', 'ro-maji', 'রো-মাজি'),
(82, 'こまかい おかね', '細かい お金', 'Small change', 'খুচরা ভাঙতি করা', 'komakai okane', 'কোমাকাই ওখানে'),
(83, 'チケット', NULL, 'Ticket', 'টিকেট', 'chiketto', 'চিকেতো'),
(84, 'じかん', '時間', 'Time', 'সময়', 'jikan', 'জিকান'),
(85, 'ようじ', '用事', 'Something to do, errand', 'কিছু করা, কাজ', 'youji', 'ইয়োজি'),
(86, 'やくそক', '約束', 'Appointment, promise', 'প্রতিশ্রুতি', 'yakusoku', 'ইয়াকুসোকু'),
(87, 'ごしゅじん', 'ご主人', 'Someone else\'s husband', 'অন্যের স্বামী', 'goshujin', 'গোশুজিন'),
(88, 'おっと / しゅじん', '夫 / 主人', 'My husband', 'নিজের স্বামী', 'otto / shujin', 'ওত্তো / শুজিন'),
(89, 'おくさん', '奥さん', 'Someone else\'s wife', 'অন্যের বউ', 'okusan', 'ওকুসান'),
(90, 'つま / かない', '妻 / 家内', 'My wife', 'নিজের বউ', 'tsuma / kanai', 'ৎসুমা / কানাই'),
(91, 'こども', '子供', 'Child', 'শিশু, বাচ্চা', 'kodomo', 'কোদোমো'),
(92, 'よく', NULL, 'Well, much', 'ভালো, বেশি', 'yoku', ' ইয়োকু'),
(93, 'だいだい', NULL, 'Mostly, roughly', 'অধিকাংশ, বেশিরভাগ', 'daitai', 'দাইতাই');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `lessons`
--
ALTER TABLE `lessons`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `lesson_vocab`
--
ALTER TABLE `lesson_vocab`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_pair` (`lesson_id`,`vocab_id`),
  ADD KEY `vocab_id` (`vocab_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `user_lesson`
--
ALTER TABLE `user_lesson`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_lesson` (`user_id`,`lesson_id`),
  ADD KEY `lesson_id` (`lesson_id`);

--
-- Indexes for table `user_word_stats`
--
ALTER TABLE `user_word_stats`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_user_word` (`user_id`,`vocab_id`);

--
-- Indexes for table `vocab`
--
ALTER TABLE `vocab`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `lessons`
--
ALTER TABLE `lessons`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `lesson_vocab`
--
ALTER TABLE `lesson_vocab`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `user_lesson`
--
ALTER TABLE `user_lesson`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `user_word_stats`
--
ALTER TABLE `user_word_stats`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=239;

--
-- AUTO_INCREMENT for table `vocab`
--
ALTER TABLE `vocab`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=94;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `lesson_vocab`
--
ALTER TABLE `lesson_vocab`
  ADD CONSTRAINT `lesson_vocab_ibfk_1` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `lesson_vocab_ibfk_2` FOREIGN KEY (`vocab_id`) REFERENCES `vocab` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_lesson`
--
ALTER TABLE `user_lesson`
  ADD CONSTRAINT `user_lesson_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `user_lesson_ibfk_2` FOREIGN KEY (`lesson_id`) REFERENCES `lessons` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
