-- phpMyAdmin SQL Dump
-- version 4.6.6deb5
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 19, 2020 at 09:31 AM
-- Server version: 5.7.28-0ubuntu0.18.04.4
-- PHP Version: 7.2.24-0ubuntu0.18.04.2

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `laravel_push`
--

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2016_07_30_000002_create_notifications_table', 1),
(4, '2019_07_27_114830_create_push_subscriptions_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `notifiable_id` int(11) NOT NULL,
  `data` text COLLATE utf8mb4_unicode_ci NOT NULL,
  `read_at` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `type`, `notifiable_type`, `notifiable_id`, `data`, `read_at`, `created_at`, `updated_at`) VALUES
('0baf53a0-75c4-419d-867d-86fd2d6ac07c', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"Thank you for using our application.\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:29:28+00:00\"}', '2020-01-19 00:36:34', '2020-01-18 17:29:28', '2020-01-18 17:36:34'),
('14ebbd43-8ba3-4faf-92a4-f8d508c4e724', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"cok asu\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:38:51+00:00\"}', NULL, '2020-01-18 17:38:51', '2020-01-18 17:38:51'),
('26616a9f-caa9-403e-92e4-342a74c52e9c', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"cok asu\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:36:44+00:00\"}', NULL, '2020-01-18 17:36:44', '2020-01-18 17:36:44'),
('4e727d68-8c6d-4ef2-9d2e-ec07547f263f', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"Thank you for using our application.\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:34:02+00:00\"}', '2020-01-19 00:36:34', '2020-01-18 17:34:02', '2020-01-18 17:36:34'),
('71ba4c26-198f-41b7-b649-6ca2a4fd05ea', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"cok asu\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:37:12+00:00\"}', NULL, '2020-01-18 17:37:12', '2020-01-18 17:37:12'),
('9743d70b-46d6-4db4-abe9-af904a2d901e', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"cok asu\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:36:38+00:00\"}', NULL, '2020-01-18 17:36:38', '2020-01-18 17:36:38'),
('a26e9d55-d8c3-4f2b-a942-4b57adf69d2d', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"cok asu\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:36:25+00:00\"}', '2020-01-19 00:36:34', '2020-01-18 17:36:25', '2020-01-18 17:36:34'),
('f18360d5-fc57-49b4-92cb-5f6209ded807', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"cok asu\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:35:55+00:00\"}', '2020-01-19 00:36:34', '2020-01-18 17:35:55', '2020-01-18 17:36:34'),
('fd893342-c2e0-48e3-aa8a-367e8c603637', 'App\\Notifications\\HelloNotification', 'App\\User', 1, '{\"title\":\"Hello from Laravel!\",\"body\":\"Thank you for using our application. woy\",\"action_url\":\"https:\\/\\/laravel.com\",\"created\":\"2020-01-19T00:35:36+00:00\"}', '2020-01-19 00:36:33', '2020-01-18 17:35:36', '2020-01-18 17:36:33');

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `push_subscriptions`
--

CREATE TABLE `push_subscriptions` (
  `id` int(10) UNSIGNED NOT NULL,
  `subscribable_type` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `subscribable_id` bigint(20) UNSIGNED NOT NULL,
  `endpoint` varchar(500) COLLATE utf8mb4_unicode_ci NOT NULL,
  `public_key` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `auth_token` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `content_encoding` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `push_subscriptions`
--

INSERT INTO `push_subscriptions` (`id`, `subscribable_type`, `subscribable_id`, `endpoint`, `public_key`, `auth_token`, `content_encoding`, `created_at`, `updated_at`) VALUES
(2, 'App\\User', 1, 'https://fcm.googleapis.com/fcm/send/cglLf9x8yDo:APA91bHtY-TOwMWjbSRShmDD08B8gXG6m7iyraK6yWPA7mbdfY2Pt2S-jvzeXuDzin3qwR_bxNVWLFj_onbBjOeJ876LeYdn5BU4uy6JtaNmr911rYW_08YIOltkEMz83fwvyB4felwO', 'BPNpMDfflvoz/BY6Pc5Ar7/rkK+4qyzbALPb3cK+UsTtQu5+2N8K0ke6HoBaHaxP0i4TChwkfsiYMYqvDBoWf+w=', 'asO4/aSKPiE+IAaMIUrDkA==', 'aes128gcm', '2020-01-18 17:37:11', '2020-01-18 17:37:11');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `remember_token` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `password`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Adsense', 'A@gmail.com', '$2y$10$26acS6qsYQimNi3ZlWmkZORZ5dDfuW.q5qZM5Iv313YK4A8fdxTd6', NULL, '2020-01-18 17:29:20', '2020-01-18 17:29:20');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_notifiable_type_notifiable_id_index` (`notifiable_type`,`notifiable_id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`),
  ADD KEY `password_resets_token_index` (`token`);

--
-- Indexes for table `push_subscriptions`
--
ALTER TABLE `push_subscriptions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `push_subscriptions_endpoint_unique` (`endpoint`),
  ADD KEY `push_subscriptions_subscribable_type_subscribable_id_index` (`subscribable_type`,`subscribable_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `push_subscriptions`
--
ALTER TABLE `push_subscriptions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
