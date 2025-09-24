'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"flutter_bootstrap.js": "711f0b0df16d5455a7b837decd9c1ac1",
"version.json": "37a5d2bd0f6adb4521123ef3b286057c",
"index.html": "b84da22e4ba256371eea765e814c6e45",
"/": "b84da22e4ba256371eea765e814c6e45",
"main.dart.js": "fe1ee14893fc459b44fc67c453978ef3",
"flutter.js": "888483df48293866f9f41d3d9274a779",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"manifest.json": "86088e4c02b887366862c120e7b3b5c1",
"assets/AssetManifest.json": "62a081f46d1a852a4306b1176f122773",
"assets/NOTICES": "0f841c55569603657e813b08f2139ce3",
"assets/FontManifest.json": "371047477a0b53e819a3a15aece8fb2e",
"assets/AssetManifest.bin.json": "ba4a27516d47b4786b385615fc9d26ad",
"assets/packages/mesh/shaders/omesh.frag": "242b80a0ff93acfab4745ef36f76f6f2",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/bubble_ds/assets/images/tooltip_arrow.svg": "d53216ab643b71dce2113d0121e4b26d",
"assets/packages/bubble_ds/assets/images/avatar_bubble.svg": "222339c8c20421caf1bf5ce82c5d370c",
"assets/packages/bubble_ds/assets/images/avatar_seen_stories_bubble.svg": "442c54ed1adacec9a0c40025abdd69a9",
"assets/packages/bubble_ds/assets/images/glassShape.svg": "425a6921f337a922a7c9fa7c841fda66",
"assets/packages/bubble_ds/assets/images/placeholder.svg": "b9b065c33b4ef68f2d43675d8d0c3c47",
"assets/packages/bubble_ds/assets/illustrations/currencies/flat/flat_currency_protection.svg": "caa267bb6a934f25bdcf6cdb04489172",
"assets/packages/bubble_ds/assets/illustrations/currencies/flat/flat_currency_raffle.svg": "c67bb536ba194851422c5aa0de147dd7",
"assets/packages/bubble_ds/assets/illustrations/currencies/flat/flat_currency_disabled_btf.svg": "4b596dfd6a810961ad67974dd4c005d0",
"assets/packages/bubble_ds/assets/illustrations/currencies/flat/flat_currency_discount.svg": "a7912d5064a87d1332d8d22ad52b9541",
"assets/packages/bubble_ds/assets/illustrations/currencies/flat/flat_currency_donation.svg": "4da6e67777096eaac1da8a00ba696b53",
"assets/packages/bubble_ds/assets/illustrations/currencies/flat/flat_currency_boost.svg": "62bf60ecbdba2790a334dedf76ee5d92",
"assets/packages/bubble_ds/assets/illustrations/currencies/flat/flat_currency_btf.svg": "ea4036cf949ef4a8ea73d0b6db21f67c",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_boost.svg": "deb24822c64b2c7e1d90cd8f2b7b1fa5",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_coverage.svg": "7607be1a3a5079fbb4dc45c5b2a9c168",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_wallet.svg": "d0c5740e5d29f02269df12cf42a9abd1",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_btf.svg": "09b4c07623733264e25d7cd039e683cf",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_donation.svg": "58451a865e8da83de401977531fac214",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_rewards.svg": "d4b5a4edd05b934f8708c9b20c3228ff",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_content.svg": "a696b497dbdc618db9fa42345403b4d0",
"assets/packages/bubble_ds/assets/illustrations/currencies/shade/shade_currency_raffle.svg": "802201271a4f043515f430920cb451e0",
"assets/packages/bubble_ds/assets/illustrations/activity/activity_holidays.svg": "52e213cb069c425dd684da8de377f7f0",
"assets/packages/bubble_ds/assets/illustrations/activity/activity_meditation.svg": "bd77b181fbc7f3abaa55183bd4b18a5b",
"assets/packages/bubble_ds/assets/illustrations/activity/activity_physical_activity.svg": "4cdb5c697a0dfd4c26706b33f1f26d67",
"assets/packages/bubble_ds/assets/illustrations/activity/activity_steps.svg": "a228072a2c2c4f37af21fff6b1d1129a",
"assets/packages/bubble_ds/assets/illustrations/activity/activity_complete_content.svg": "32dac112076cac680d09ba8a92b1a4dc",
"assets/packages/bubble_ds/assets/illustrations/activity/activity_birthday.svg": "77b90ccf4b337c907097e856e8423d63",
"assets/packages/bubble_ds/assets/illustrations/product/donation/social_causes_tree_donation.svg": "58c06874df2ee163ce6ed9914466fb7e",
"assets/packages/bubble_ds/assets/illustrations/product/donation/social_causes_water_donation.svg": "8c1fce9a56c79688dd13357b846e0bd3",
"assets/packages/bubble_ds/assets/illustrations/product/donation/social_causes_food_donation.svg": "bd059362bc9421e6e70d8f7ac63ee3cb",
"assets/packages/bubble_ds/assets/illustrations/product/donation/social_causes_donation.svg": "7718d086a6db681266e853476f7381eb",
"assets/packages/bubble_ds/assets/illustrations/product/social/social_leaderboard.svg": "baaa63c36dd631f72324b4ade02f8243",
"assets/packages/bubble_ds/assets/illustrations/product/social/social_challenge.svg": "8a2571e3c7a767823140f68ffa4055c3",
"assets/packages/bubble_ds/assets/illustrations/product/social/social_group_challenge.svg": "778f3138b6389e026c8519abc57d9d32",
"assets/packages/bubble_ds/assets/illustrations/product/social/social_personal_challenge.svg": "e7efa9bb5cc6b6c2a92a994d138342e4",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_empty_data.svg": "f5660402a49ad4f60122f071f658ce30",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_benefits_empty_state.svg": "a11e4d035980175b431e1fa0179ae56a",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_request_sent.svg": "25e1dda1788dca01fa93ff5ad712f7b0",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_transaction_done.svg": "8f998354a669ffacc71e8a2e4d79b18d",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_code.svg": "db9f7b278dc943fb21afffd45e8b854b",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_failed_process.svg": "4c472d617852b69645c8bb3856a69f68",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_load.svg": "3afc112bcbdeb1679c985cfec08cb76c",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_password.svg": "2926d29ec71b84670d85804318be02bf",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_no_connection.svg": "ee21052d92d641e7cb719279768dc162",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_upload_information.svg": "6c314bbd60a0f4e18108c6ef148e3d98",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_construction.svg": "dfc80bd15b68274601b463d225471316",
"assets/packages/bubble_ds/assets/illustrations/product/states/state_error_failed.svg": "11c61ab65c432b9c48bb7506645e3591",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_coverage.svg": "8aea28ea76c709a43f7785de8d0d2b49",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_phone.svg": "f4f559fa63df6f8c660b0101a2a1d28d",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_cancer.svg": "2a28f4eb47b7543434aa3a791cd92e48",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_pharmacy_discount.svg": "2a610ad3a94db4e6efbd68c5926d0522",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_dental.svg": "4663114eb7798d1a2dad7f20f7083a06",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_notification.svg": "da756abec5a1ed050ba3bdd201dfa046",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_pet.svg": "082986f7224116538b007ee79d6b58d7",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_bonus.svg": "8154b6fa0a44cc150ba526aeca700330",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_bike.svg": "b202c40333c98bf09a3fe337da2b50ed",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_life.svg": "218d25deb8664b011b6c74429af3f08c",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_car.svg": "f18e6f833457eb786e5cc56c9d02b1f4",
"assets/packages/bubble_ds/assets/illustrations/product/insurance/insurance_supplemental_health.svg": "0aa9a443a00794a48328a3e6b58e1319",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_mindfulness.svg": "2ebd1615ecba07146a6ac22ac72a14b2",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_calories.svg": "fe35b810e84c5ed96633c17ba8db1718",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_gratitude.svg": "7fbd16f08b9aad2abb4ea191bb8295d4",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_relationships.svg": "b68cb18e576ce9921bfe6bbce9b78498",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_finances.svg": "d9363225befcfaf5efe77da772fe4371",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_nutrition.svg": "a7a3fceaa4cb15404aee96e18b957b85",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_sleep.svg": "ebad3648a5a8d713eb7a0368ff89c8f4",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_giving.svg": "55423112b7f5a9037debb452d44680d5",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_relationships_2.svg": "63e74a4633f9f16170ba6c7f51d3a470",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_learning.svg": "c6d09d3da22202c3f2e62ac84fa96a51",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_dreaming.svg": "7f624f69d8899691156c8ebc3e15b139",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_distance.svg": "84b6fa3fc4c4713b75941db8733bc04e",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_points_wallet.svg": "6b70662b6985f9d117933baf7cb5e605",
"assets/packages/bubble_ds/assets/illustrations/product/wellbeing/wellbeing_movement.svg": "9c1899790bd10d5d3ad82ede0bbdaad7",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_meditating.svg": "a671c95a4259d7744d9c8669b82cf738",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_life_insurance.svg": "c88252ec59c8f69f9ac9c765a117620f",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_thumbs_up.svg": "766f59106c362f4b332051817d191e61",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_working.svg": "50ccea267f025f4643bb14b3acde1fb1",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_waving.svg": "a37d041017805535f71a33142b099cc1",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_health_insurance.svg": "2b7d72622d9870b45ab7a6678cf44329",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_dental_insurance.svg": "599150491c7a853a0408475f8914b48e",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_pharmacy.svg": "0e831c26ce052618f5e1695e917a8e52",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_bonus.svg": "75cb89bb526a9bb103bef305bb14e768",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_celebration.svg": "1d6e13a83d3b40638f6fde3b1402f210",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_pet_insurance.svg": "c017d5ccc7125ebffa01229bb798e799",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_cancer.svg": "4b888870528a8236aee1dd769bd4f30e",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_bicycle.svg": "30159cbead90434d114f04ba10b833d6",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_reading.svg": "764a027a0cd28ce2c04dd53a267ccba9",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/poses/buddy_poses_running.svg": "0fa4e4c2538c2abf889595c45a82be94",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_worried.svg": "aaedef455a0bf64d8bad41387f321e22",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_birthday.svg": "ce5e0042e5d89b301a3b07ddb8231597",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_thinking.svg": "b7d123e76d60a993f38f56cb6581a4b4",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_concern.svg": "b71d19f88de72f78be3e6b119455ca54",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_joy.svg": "bb29143311df3fead07d1d43a6a32925",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_poker_face.svg": "ad14c8f789a9e85b5683e593a3b43cbc",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_thank_you.svg": "cfae26365057e566a03e41787b5c8823",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_happy.svg": "1b70c33293a2224288aeca3e7aeb9150",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_surprised.svg": "5fffffb471d9785c0c226ac27dfe7bfb",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_confident.svg": "af185ebfcb1161ccc582767578d640d8",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_excited.svg": "6f933e66191657691065f0fa126cce77",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_doubt.svg": "6c0edf59da61d2a92fc773ee96f09f33",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_joy_currency.svg": "1f33e639c9ced2e200527a451c77913f",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_locked.svg": "b14d0e1aa5cded2975e40c8e3e0c51c1",
"assets/packages/bubble_ds/assets/illustrations/buddy_universe/faces/buddy_face_sorry.svg": "97e6516210ba0fb8b3706fb1860b8842",
"assets/packages/bubble_ds/assets/icons/navbar/navbar_benefits.svg": "8b84a78262f90e138225ab966d68e463",
"assets/packages/bubble_ds/assets/icons/navbar/navbar_home.svg": "2061676027565df2af3b59dce9f21b31",
"assets/packages/bubble_ds/assets/icons/navbar/navbar_social.svg": "cf9d0f421fb5d3870909115e32504e4d",
"assets/packages/bubble_ds/assets/icons/navbar/navbar_profile.svg": "0f0b9ccb1e88018a91461180c2adfc53",
"assets/packages/bubble_ds/assets/icons/navbar/navbar_journey.svg": "977839877f5b490d12be98163b2d17d1",
"assets/packages/bubble_ds/assets/icons/interface/search.svg": "ba9c903e59c5585f21c4f9eaefbc41d1",
"assets/packages/bubble_ds/assets/icons/interface/like.svg": "b791a076781ed3e1616dd7ff3fdd4efa",
"assets/packages/bubble_ds/assets/icons/interface/target.svg": "bdd6336b6895449e368ea4a9f8288e21",
"assets/packages/bubble_ds/assets/icons/interface/event_error.svg": "59766dc1e1ebb1ca911d9af171d7a415",
"assets/packages/bubble_ds/assets/icons/interface/home.svg": "fcd2b2a239e35f0968ef106841c1bbcf",
"assets/packages/bubble_ds/assets/icons/interface/alert.svg": "9e07599b3ba1b35ddd92afb419c4a198",
"assets/packages/bubble_ds/assets/icons/interface/out.svg": "a2b283610af96a85e19202bb7f5c05b6",
"assets/packages/bubble_ds/assets/icons/interface/radio_unselected.svg": "6cd22f4529943b124da95070014c7b3a",
"assets/packages/bubble_ds/assets/icons/interface/favourite.svg": "3e6defcb28100bb3eaad794aa7dddac8",
"assets/packages/bubble_ds/assets/icons/interface/log_out.svg": "f0c115b7fb6895f3aadf33f3233813b9",
"assets/packages/bubble_ds/assets/icons/interface/down.svg": "2f74cd40ecdf81a18da28714b02ce250",
"assets/packages/bubble_ds/assets/icons/interface/storefront.svg": "9f7cdedb313bdf1fde5fa4e2e2f981e3",
"assets/packages/bubble_ds/assets/icons/interface/files.svg": "9a01ca212f14f00a54cc3167e374ed36",
"assets/packages/bubble_ds/assets/icons/interface/send_post.svg": "fa9fc0e3baf73045ecb477f35f06cb61",
"assets/packages/bubble_ds/assets/icons/interface/password_show.svg": "f87fcf3e2832573d920e2bbadcbae095",
"assets/packages/bubble_ds/assets/icons/interface/alert_fill.svg": "16a2751759f3e9c3ea77abeab9995d6a",
"assets/packages/bubble_ds/assets/icons/interface/in.svg": "9ffe1819e1c9a2f943cd3cd6151c4ffa",
"assets/packages/bubble_ds/assets/icons/interface/all.svg": "4adb429f0c12c3fb0499ceef34cc0650",
"assets/packages/bubble_ds/assets/icons/interface/lock.svg": "f1f15eeb0f471d9f4159305584f40bb9",
"assets/packages/bubble_ds/assets/icons/interface/id_card.svg": "59d260f908530b52511be411346f7d35",
"assets/packages/bubble_ds/assets/icons/interface/event_add.svg": "1ffa5cb65050708756ddcec5b3933465",
"assets/packages/bubble_ds/assets/icons/interface/alt_email.svg": "8cec75dfb1fb52b8f51202c04df4801e",
"assets/packages/bubble_ds/assets/icons/interface/settings.svg": "cf43763adbe891ff8811fc5a4c4545cd",
"assets/packages/bubble_ds/assets/icons/interface/cart.svg": "d916499ee34d673850fe4168b8d28d77",
"assets/packages/bubble_ds/assets/icons/interface/error_fill.svg": "f6a0639a1a16f2c238a64f925f27b9ce",
"assets/packages/bubble_ds/assets/icons/interface/new_post.svg": "3df4e9308769f055520f7d1e27fa5b2e",
"assets/packages/bubble_ds/assets/icons/interface/download.svg": "d9768ce87a2a3ba5a448bb99b4d29690",
"assets/packages/bubble_ds/assets/icons/interface/event_start.svg": "9a9f76650bcca3e45a3fe3e681259b56",
"assets/packages/bubble_ds/assets/icons/interface/checkbox_unselected.svg": "406468aaa9fe252879fbdea84e613c40",
"assets/packages/bubble_ds/assets/icons/interface/chevron_right.svg": "7df69538335c3a006e3c4ac30f8ff836",
"assets/packages/bubble_ds/assets/icons/interface/chevron_left.svg": "c15575e430ae53bf6b75c9e7a7380bc6",
"assets/packages/bubble_ds/assets/icons/interface/stop.svg": "00459d7ed68ab788942536c4b5fd20f5",
"assets/packages/bubble_ds/assets/icons/interface/check.svg": "e636813d25affcca42e8497ea0504dbf",
"assets/packages/bubble_ds/assets/icons/interface/options_horizontal.svg": "aa80ed238fe629846ec861661b2d7c53",
"assets/packages/bubble_ds/assets/icons/interface/email.svg": "6bfa8e04146838c7f41a4dc74ae87ffa",
"assets/packages/bubble_ds/assets/icons/interface/info.svg": "07eb8fdd267e3e35aa6b03156f107a46",
"assets/packages/bubble_ds/assets/icons/interface/add.svg": "06a0fca69fa1490d365dce600bfc2653",
"assets/packages/bubble_ds/assets/icons/interface/close.svg": "01d835bc466cb182b4f20cc4eff077d7",
"assets/packages/bubble_ds/assets/icons/interface/copy.svg": "7e970df61c3a109f43bd763b40b59e91",
"assets/packages/bubble_ds/assets/icons/interface/pending.svg": "35cc07a7e43572e16a567ca730d8af38",
"assets/packages/bubble_ds/assets/icons/interface/password_hide.svg": "84770c9888417ebce6e519a34a45abe1",
"assets/packages/bubble_ds/assets/icons/interface/refresh.svg": "754a5a50eea31ac7eb2a336d4434bc53",
"assets/packages/bubble_ds/assets/icons/interface/checkbox_selected.svg": "110686037768c21e62829d1ed3a83a0f",
"assets/packages/bubble_ds/assets/icons/interface/international.svg": "f67da1e04a4d9d6d54418731bdc1f164",
"assets/packages/bubble_ds/assets/icons/interface/chevron_up.svg": "5d12981d1b546db7289ffcf27f88450e",
"assets/packages/bubble_ds/assets/icons/interface/success_fill.svg": "fb52e9147d98020f236c94c7a2b318ab",
"assets/packages/bubble_ds/assets/icons/interface/back.svg": "7132062b3520044d3edf198c15507fd1",
"assets/packages/bubble_ds/assets/icons/interface/edge_chevron.svg": "dc22ddae988e1e289846b03659d527c9",
"assets/packages/bubble_ds/assets/icons/interface/play.svg": "9e9627345b27afef89616c24ad642e82",
"assets/packages/bubble_ds/assets/icons/interface/radio_selected.svg": "7a067861346a659fecdd522947ac2a99",
"assets/packages/bubble_ds/assets/icons/interface/notification.svg": "c9a69d31e5b518b7b99521aa30dac3de",
"assets/packages/bubble_ds/assets/icons/interface/send.svg": "f5e6e85a08d28c217886fa60b5916d38",
"assets/packages/bubble_ds/assets/icons/interface/info_fill.svg": "0e70b0cee3d63740fecf2fc7ffb484ad",
"assets/packages/bubble_ds/assets/icons/interface/checkbox_indeterminate.svg": "55e0f77979f6ad46394521c072d55416",
"assets/packages/bubble_ds/assets/icons/interface/edit.svg": "97e4915616dbe5dcc8a1948c82feb3dc",
"assets/packages/bubble_ds/assets/icons/interface/save_post.svg": "65dbc480205fdbd926c076933ac78000",
"assets/packages/bubble_ds/assets/icons/interface/next.svg": "9c0f58018b37282606c6a8edb8e25c2d",
"assets/packages/bubble_ds/assets/icons/interface/chevron_down.svg": "2c6d40596ee85cf9bdea42e9e65b62f6",
"assets/packages/bubble_ds/assets/icons/interface/unlock.svg": "d5206b0608a29c0a23c570220ad499f2",
"assets/packages/bubble_ds/assets/icons/interface/delete.svg": "407490792e95772eca492bf4bc956daf",
"assets/packages/bubble_ds/assets/icons/interface/person_multiple.svg": "3737d79a9eafa4a08754c489bf95dffb",
"assets/packages/bubble_ds/assets/icons/interface/success.svg": "14fe3f02876a34e98a6da962407b4db1",
"assets/packages/bubble_ds/assets/icons/interface/sync.svg": "b3b32b0f7cc19b1d77454a211eaeb211",
"assets/packages/bubble_ds/assets/icons/interface/rotate_right.svg": "d3eb4a6d8eee99de3ca0ccfa38490528",
"assets/packages/bubble_ds/assets/icons/interface/new.svg": "8d70f72d672130d58b08726a775f6df5",
"assets/packages/bubble_ds/assets/icons/interface/options.svg": "9ffb3e2d0d8fccb7e2b0567b25a18854",
"assets/packages/bubble_ds/assets/icons/interface/profile.svg": "a9c24f27bd2deb282e7593cb5f1d9ebc",
"assets/packages/bubble_ds/assets/icons/interface/share.svg": "d69fe808d6d41d679c7f0b6e121c4729",
"assets/packages/bubble_ds/assets/icons/interface/filter.svg": "ef183bd6dcb5111778fb913e79bdf06d",
"assets/packages/bubble_ds/assets/icons/interface/pending_fill.svg": "4df17625eb1ed4fae99fbdbd85baff43",
"assets/packages/bubble_ds/assets/icons/interface/ios_share.svg": "d624853a7ec15d2ae6959317bd44444d",
"assets/packages/bubble_ds/assets/icons/interface/comment.svg": "fba61a3010037321012418a9e396d6d0",
"assets/packages/bubble_ds/assets/icons/interface/add_person.svg": "bfe31346ea49b27491a1c9a4e5a9c2d9",
"assets/packages/bubble_ds/assets/icons/interface/error.svg": "12c7a261b9c8fdb412fb13853dc4190d",
"assets/packages/bubble_ds/assets/icons/interface/upload.svg": "38e5a458635e7b9ade7a7b1efc56f223",
"assets/packages/bubble_ds/assets/icons/interface/date.svg": "d27c44ec42cb9ec9733a7c0fe22c76c0",
"assets/packages/bubble_ds/assets/icons/interface/help.svg": "9eb5cfa3603660be36b83de898a11bed",
"assets/packages/bubble_ds/assets/icons/interface/company.svg": "97a6fbd9834faddabacca4dffc577b80",
"assets/packages/bubble_ds/assets/icons/interface/event_ends.svg": "bc7a0bfa618835d0411a353eb7393173",
"assets/packages/bubble_ds/assets/icons/interface/menu.svg": "692ee0029565f407859977626c2fb048",
"assets/packages/bubble_ds/assets/icons/interface/password.svg": "199e8ebe9e2b16bf7f1988b08794cbac",
"assets/packages/bubble_ds/assets/icons/interface/history.svg": "773eece9e672800222dd9c5461a5dda4",
"assets/packages/bubble_ds/assets/icons/interface/users.svg": "b848122fe06fbbaa306aaff8299f2f53",
"assets/packages/bubble_ds/assets/icons/interface/minus.svg": "716361642649d76d69dd8b80112d4ba5",
"assets/packages/bubble_ds/assets/icons/interface/remove_person.svg": "f3e2c1eaa15340693dcc26921f001315",
"assets/packages/bubble_ds/assets/icons/pictograms/others_general.svg": "327d7adef1569b91777382b8af2de0ce",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_plan.svg": "eb9da10e09d7ace4d0f457187c26efb7",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_diving_1.svg": "f90a9dcf599c791011f2ecbeb3685fcb",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_stadium.svg": "a94f6a29e89c980eff857f04538d6081",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_settings.svg": "95c2309645f69135a5edf53bdbf55132",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_ice_skate.svg": "2df1532d3ddfe2fb16722979034d212b",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_rewards.svg": "a9ad1cfb439dc4f4de8e34bc252cd065",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_archery_1.svg": "4d31167a051faa399400bb80f452f8f3",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_stopwatch.svg": "6f39fe0965f444c3f95b2d58623e05b3",
"assets/packages/bubble_ds/assets/icons/pictograms/others_products.svg": "bccdb3a4a8263063d481b3e9956901a2",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_golf.svg": "d55e38e5fe04493bc10dedd28ab3a918",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_soccer_ball.svg": "4e74f33d5eeb92e0dd9cdda971b7fcc0",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_meal.svg": "43ec4de95d7aee8fba6d7ceee830f841",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_first_aid_kit.svg": "19c781e93b55440fc4d378daefc5867c",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_impact.svg": "8e651f10f548bf8438654a5dfd4d67cf",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_coverage.svg": "1159a3bb128585ef9cb9e210689a8323",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_international.svg": "2f8fb6d4dd5109a65711b62b4662c6ca",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_tennis_ball_1.svg": "b81c5aee2cee01f79bcc467f01064272",
"assets/packages/bubble_ds/assets/icons/pictograms/others_contacts.svg": "eb926584a4be7d2cbd4a5bcd7a52515f",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_chess.svg": "4a80f6ed42ecc607a0e5cd6e8c484955",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_birthday.svg": "ce2e0f023fb9e9a7c8c474b83b840612",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_fishing.svg": "8dc03248cf49dfd5729b299dab73e103",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_logout.svg": "e66260d907ebf30c94f4ade524ec0e64",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_activity_complete.svg": "4d565e7a751a3f9d7ba4057469128f84",
"assets/packages/bubble_ds/assets/icons/pictograms/others_fav.svg": "150bd6354e6e969631de0c1ecd200360",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_skate_park.svg": "28ee8231801046edcb036b748e2d752a",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_sock.svg": "ccb132cec7ebdfb262c9da8235b75676",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_socks.svg": "bbea270245742a2da453e3eed3ecbbde",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_baseball_ball.svg": "73ecef0d053703d2d2ec0a1ee1c74657",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_stage_1.svg": "482ba53ef59b86820fdccac9eea31c18",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_hockey_stick.svg": "9b6834fb2d22ea642d32991a34927829",
"assets/packages/bubble_ds/assets/icons/pictograms/others_image.svg": "dd02a5412e656ec9f6d60c14d8f9b7cd",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_corner.svg": "7980fed9d1bba8dcb2a878f5e2771f28",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_volleyball_ball.svg": "3e28f2d457f7c6a4c8d032be24e6edc9",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_cancer.svg": "9b604d781ee1af82f02c9c0cd41c877c",
"assets/packages/bubble_ds/assets/icons/pictograms/others_clients.svg": "293ca21172b79fa59e3a0ac8ec03c20e",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_stage_1.svg": "482ba53ef59b86820fdccac9eea31c18",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_videos.svg": "75015a28c920b5d441477ab03470319a",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_football_american.svg": "31ecf0491dd37b7faaa0330973d33259",
"assets/packages/bubble_ds/assets/icons/pictograms/others_app_settings.svg": "95c2309645f69135a5edf53bdbf55132",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_medical_expenses.svg": "4d1149ece0fcdded5b8441fbf0c4f680",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_dental.svg": "739acca2f41502f118fba57666444653",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_t_shirt.svg": "bacd9cec3672fae82761eca23b210224",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_basketball_hoop_1.svg": "23526db589c057979ee1212b6401dc03",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_wallet.svg": "e416b2533b75cb55b1615a091bbd829e",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_mindfulness.svg": "a975ef0c9d6b7a1446da80e658056efa",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_boxing_1.svg": "6284da070f9e10364dfaa2dc05fcff97",
"assets/packages/bubble_ds/assets/icons/pictograms/others_connection_error.svg": "72e02ab5083446b310352b131bba5b3c",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_track.svg": "4136c9310329b0e79eb59f690176e071",
"assets/packages/bubble_ds/assets/icons/pictograms/others_activation.svg": "65e552d0b670e68628c7df446b22e750",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_rings_athletic.svg": "50135834c81bc2618b757a0065a89f76",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_jersey.svg": "bacd9cec3672fae82761eca23b210224",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_football_shoe.svg": "d5020e1587c88dffce60f4426e69bd32",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_award_1.svg": "3f81232687211191e7a1e93c6422ed76",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_tree.svg": "3b5aa395bc614db043e19d3b8ab27938",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_tips.svg": "e01670f38a9813cb85460a83894e4d46",
"assets/packages/bubble_ds/assets/icons/pictograms/others_billing.svg": "af544f8e19b19b2afc7e194460cc4bff",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_seu_vale.svg": "9e044adb31cb3b4283a29164835c278c",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_game_structure.svg": "59c2c627e66e1c0f08f86a0e345f5f0b",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_kayak.svg": "23e0d9706718e66455017585c9f4bb00",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_certificate.svg": "5de0f426f3ec5b137fe7c19d5c14e4e8",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_gratitude.svg": "a4f8b3c86199c2d2bebc5bdb935d19be",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_sync_node_complete.svg": "4d565e7a751a3f9d7ba4057469128f84",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_basketball_jersey_1.svg": "bacd9cec3672fae82761eca23b210224",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_id_card.svg": "8aa78aace31bcd98d8ce6cf134cb73b6",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_football_american_1.svg": "4ba4a024b4c8b88958a8cffaf8b070dc",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_drink_water.svg": "2a9ee28e6bf9087e2426c60fb7f814a8",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_no_coverage.svg": "ca1c52e6b53540d1a01c3677821d7f75",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_legal.svg": "7541c74a37ba983a84abf67b01a607e8",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_helmet.svg": "c5d20401f7b10b5a2ec911a61f196d0e",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_baseball_field.svg": "9bed83981b2830d4f156e46e1562e4df",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_active_pause.svg": "92eec8349b4fd543f389972496672a8e",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_dumbbell.svg": "d27c08ea747ef24133a68497188a0e43",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_shorts.svg": "4582281022b4423ce9353f8d24e19ba6",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_end_challenge.svg": "763310347ba44495b442a6caa3c71280",
"assets/packages/bubble_ds/assets/icons/pictograms/fr_transportation.svg": "2ccc56eca654a035f195b286315bcd53",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_vet_online.svg": "1607d09ac92c6717715e4749081b25f5",
"assets/packages/bubble_ds/assets/icons/pictograms/others_fab_closed.svg": "53afc5be6daa336309241cdd2c17cdad",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_donation_node_complete.svg": "4d565e7a751a3f9d7ba4057469128f84",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_bandage.svg": "9e9ec4e363d9ea1e8d3c9419e269dfdd",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_basketball_ball.svg": "23526db589c057979ee1212b6401dc03",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_tennis_court.svg": "0518d7ac05679ce331134626fab18fdf",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_baseball.svg": "28bb297c3074d9ccfd17b5667361806f",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_money.svg": "c86a08f6d0db2ac12e02471ab93736e0",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_quizzes.svg": "48f2258c508c3fe208fc19515350446a",
"assets/packages/bubble_ds/assets/icons/pictograms/others_users.svg": "319a73cc41e7a0a2ae17eb559bffe703",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_hearphones.svg": "600f8aec8cefd21489a99bf3f2903d14",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_soccer_field.svg": "97ceef89c79514467046316c70b87556",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_timetable.svg": "38d4c9a129a5487db5372e0de558a64b",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_whistle.svg": "c29d9d7f98ca222e0253a3b312035045",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_surfing_1.svg": "afaf912a8244d0ad13afaa4bfca7c554",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_team_1.svg": "293ca21172b79fa59e3a0ac8ec03c20e",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_myocardial_infarction.svg": "8c11253dd6071087c16163adc6edcf80",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_doping.svg": "b2cc28098b626cdc33abdcd0b5b5e87b",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_table_tennis.svg": "d37036dd8586589f6ef789e528423601",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_beach_soccer.svg": "dfbb31f34a4da92256cb594d77f5628a",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_home_new.svg": "a7fb610050f788f275f87624d46bce17",
"assets/packages/bubble_ds/assets/icons/pictograms/others_search.svg": "40ecd1829758c2832a5f3435f045d7a5",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_punchbag.svg": "107757287af31382e2432c831637ef9d",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_employees.svg": "293ca21172b79fa59e3a0ac8ec03c20e",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_sleep.svg": "58e1b3fd8c5518100b859938e693cdbb",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_female_player.svg": "4527d1a49cd2eb727eab669229cabca0",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_backpack_1.svg": "24644dabd6d258535c539f9b844e16b9",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_boxing.svg": "6284da070f9e10364dfaa2dc05fcff97",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_time.svg": "7d51c5693d9c0ae4b2477ae63cdd86a3",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_mission.svg": "4d31167a051faa399400bb80f452f8f3",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_rugby.svg": "31ecf0491dd37b7faaa0330973d33259",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_infarction.svg": "8c11253dd6071087c16163adc6edcf80",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_dreams.svg": "192cb94425bb4ecf1ca855fe30a3fd21",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_bowling.svg": "2f86f9525f7dd04fd1fdccbf9a7949e1",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_steps.svg": "6ec582f8bb12549d5f900478d818d801",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_languages.svg": "4bd716b3d8406bd6df90a980bd44e609",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_swimming.svg": "7b679044d530154b410a2f9d6b5bb74c",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_badminton.svg": "88b4d49bceba46ea20d1a6f35633b3a0",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_golf_1.svg": "d55e38e5fe04493bc10dedd28ab3a918",
"assets/packages/bubble_ds/assets/icons/pictograms/others_location.svg": "244c0204b23f91440394107e87820511",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_metrics.svg": "ea26caa64f46331682bf32398b7eb65b",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_survey.svg": "48f2258c508c3fe208fc19515350446a",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_fitness.svg": "d27c08ea747ef24133a68497188a0e43",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_cerebral_stroke.svg": "ba220b0f19d4c3883c2c040796b05e50",
"assets/packages/bubble_ds/assets/icons/pictograms/fr_credit_card.svg": "9e044adb31cb3b4283a29164835c278c",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_accidental_death.svg": "5c6564108e6e59e1d9efe8b2488c0a90",
"assets/packages/bubble_ds/assets/icons/pictograms/others_operations.svg": "bccdb3a4a8263063d481b3e9956901a2",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_stage.svg": "0ff374431ebf3bb126991b9479e69676",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_sport_jacket_1.svg": "43c79d8745eb4cb1e83aa7da4bf407a8",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_swimming_pool.svg": "f87d579522ab6bedd9d0062238a04e7f",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_roller_skate.svg": "7607b4eaf44b9e760002afa983f5773f",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_skateboard_1.svg": "031f1e5f79ea6962ca7590fa7e5f2238",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_education.svg": "1d8db9791bd71374884bb3f026900f6f",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_nutritionist.svg": "0f907e9a3e50b06684cabfc338ee9ed5",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_dumbbell_1.svg": "d27c08ea747ef24133a68497188a0e43",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_male_player.svg": "4527d1a49cd2eb727eab669229cabca0",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_fencing.svg": "18c58deb8d2d95994bb082a93ac7a17b",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_stage.svg": "482ba53ef59b86820fdccac9eea31c18",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_payments.svg": "18c4ea19f82444895ddf47b5fd3f2fac",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_trophy.svg": "d842ae82236dd94ca83c9fb5f2edc3ce",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_group.svg": "165d1092c345f221ec7c698716509e6b",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_donation.svg": "224e33dafae7656b95109cfedc13f69e",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_shoe.svg": "74236eb585a90b0d8529f69c4e96b4af",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_net.svg": "670a7db5263bdfe52ecc6e8ecc28adf2",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_broke_bone.svg": "6c1a633fef7f093a6ef849d2daff64e5",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_tennis_ball.svg": "b1d42f5bb3a0156b8ac4e625ea49a74b",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_diving.svg": "f90a9dcf599c791011f2ecbeb3685fcb",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_recognition.svg": "3f81232687211191e7a1e93c6422ed76",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_surfing.svg": "6ec04cf3fdad7f71d25224e1b4319bd8",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_game_structure_1.svg": "59c2c627e66e1c0f08f86a0e345f5f0b",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_milestone.svg": "4d565e7a751a3f9d7ba4057469128f84",
"assets/packages/bubble_ds/assets/icons/pictograms/fr_children.svg": "d023f279169ffaf39f399365369ef71c",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_save_money.svg": "846c0077dcb0497ef8c933075963121e",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_saving.svg": "6929e3146b2af8757a72315197c1b05d",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_discount.svg": "4c6c7e821b3484462bfef6458f827165",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_celebration.svg": "c8e9ec5617843b3aeeb66b0c476c2729",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_trophy_1.svg": "d842ae82236dd94ca83c9fb5f2edc3ce",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_gift_card.svg": "bddb7509d1ebe5e45c2f6e51b84d3b63",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_start_challenge.svg": "800aa206278e70e8660bf638a9b15a8f",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_basketball_jersey.svg": "bacd9cec3672fae82761eca23b210224",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_football_helmet.svg": "01e9d0b3c20382e67b552dbd4a670c5c",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_backpack.svg": "24644dabd6d258535c539f9b844e16b9",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_badminton_1.svg": "a873132e7f7052d768b4afc9adc327b0",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_bicycle.svg": "353d8411c30a01902f527acb9ba52b66",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_hockey_sticks.svg": "9b6834fb2d22ea642d32991a34927829",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_award.svg": "3f81232687211191e7a1e93c6422ed76",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_content_node_complete.svg": "4d565e7a751a3f9d7ba4057469128f84",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_medicine.svg": "abb564167e10ca075552b8928ee883d4",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_racing.svg": "c1dfd968c954c00a02d6f8cc8fa8bd53",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_versus.svg": "1b01cf1bc4ab64b3926247cf66efd035",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_accidental_disability.svg": "7dd27e63d5ba871eb9571de1ccf87a25",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_basketball_hoop.svg": "23526db589c057979ee1212b6401dc03",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_stolen_bicycle.svg": "95ae158249f618865aa5524a3211952d",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_sport_jacket.svg": "e461d97951b50e17fb8d933855c3dce9",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_psychology.svg": "c19da96e3130dfbd3c81feac4fe4db3b",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_helmet_1.svg": "c54bc4d6ed29469950f69dacf7fbee24",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_discount_club.svg": "bfdb1ab745f5391c28ceeafe9f4f98e0",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_glove.svg": "bbd33e3acb6620921002f8163e99b448",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_telemedicine.svg": "e89a662be330bca0e0512bdf11077c7c",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_medicine.svg": "e89a662be330bca0e0512bdf11077c7c",
"assets/packages/bubble_ds/assets/icons/pictograms/others_support.svg": "a8dfe761bbc4696abc786d2e2715c137",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_run.svg": "634b7d505a78d6c336d54ed0f1a5cdca",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_medal_1.svg": "3f81232687211191e7a1e93c6422ed76",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_basketball_field.svg": "97ceef89c79514467046316c70b87556",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_bike.svg": "353d8411c30a01902f527acb9ba52b66",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_complementary.svg": "50e37afcec5ef0a34b0723210376586f",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_badminton_court.svg": "942159e569ec0e3b54e9f92b2f9c3632",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_remote_work.svg": "7d6099846f61213591fb2ec047905a41",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_referee.svg": "17316cb344996edfbfd1541589ff638d",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_calories.svg": "1013cad535af44849e747d448c687df1",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_holidays.svg": "9ed7af4095d2cc0afd76cad0533d7c04",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_table_tennis_1.svg": "d37036dd8586589f6ef789e528423601",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_learn.svg": "75015a28c920b5d441477ab03470319a",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_archery.svg": "37ac8202ab446600495cabe36590ec75",
"assets/packages/bubble_ds/assets/icons/pictograms/others_settings.svg": "95c2309645f69135a5edf53bdbf55132",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_bowling_1.svg": "2f86f9525f7dd04fd1fdccbf9a7949e1",
"assets/packages/bubble_ds/assets/icons/pictograms/others_content_warning.svg": "c8336a5c75a80ba4c945682a100c6188",
"assets/packages/bubble_ds/assets/icons/pictograms/others_plans.svg": "4176b567728db5f116b499ca6cdd9015",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_skateboard.svg": "953528cac2dc7120ed809bec0229c193",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_card.svg": "dc2a652defe700d75f105a6f5f93d8f7",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_time_of_screen.svg": "34edfcaf0ab27f507cffb5a8a34a1b34",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_body_and_mind.svg": "a975ef0c9d6b7a1446da80e658056efa",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_team.svg": "293ca21172b79fa59e3a0ac8ec03c20e",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_bike.svg": "353d8411c30a01902f527acb9ba52b66",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_family.svg": "293ca21172b79fa59e3a0ac8ec03c20e",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_bowling_ball.svg": "2f86f9525f7dd04fd1fdccbf9a7949e1",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_car_insurance.svg": "b0f8dc1b56c9822300b4b8c181c8d855",
"assets/packages/bubble_ds/assets/icons/pictograms/others_service_error.svg": "98c41e92a5a04b5d1254960dd5be7e84",
"assets/packages/bubble_ds/assets/icons/pictograms/wellbeing_screen_time_minutes.svg": "ac4ef54ed8bc5fbcd90aea4b8acb313c",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_medal.svg": "ec74934a08aceebb66d575ab5c1d87cc",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_billiard.svg": "bf4541d989822485b9f89c3d414bea8e",
"assets/packages/bubble_ds/assets/icons/pictograms/rewards_gift.svg": "a9ad1cfb439dc4f4de8e34bc252cd065",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_water.svg": "0f5e2d17537d2fb47475c3c720bdc724",
"assets/packages/bubble_ds/assets/icons/pictograms/clients_portal_communicate.svg": "b79bd5e1472495dc115d4bbdd35e66f1",
"assets/packages/bubble_ds/assets/icons/pictograms/sports_trophy.svg": "d842ae82236dd94ca83c9fb5f2edc3ce",
"assets/packages/bubble_ds/assets/icons/pictograms/insurance_hospitalization.svg": "0659c3e64bcd3a79de0f34c256ba8eef",
"assets/packages/bubble_ds/assets/icons/pictograms/activity_group_challenge.svg": "529b05cfb2012517cecf47d6c70e2a44",
"assets/packages/bubble_ds/assets/icons/spinners/spinner_inverse.svg": "7489df36f8a3831be38ed40866c4cda5",
"assets/packages/bubble_ds/assets/icons/spinners/spinner_error.svg": "30dff3f4ddf6ead8feb4b71a4a916a76",
"assets/packages/bubble_ds/assets/icons/spinners/spinner_black.svg": "3e5ca62458b89a67e36c6f2890a7b014",
"assets/packages/bubble_ds/assets/fonts/obviously/Obviously-NarrowBold.otf": "b57f6fbbdf64929ae2a5538950c00805",
"assets/packages/bubble_ds/assets/fonts/roboto/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/packages/bubble_ds/assets/fonts/roboto/Roboto-Bold.ttf": "b8e42971dec8d49207a8c8e2b919a6ac",
"assets/packages/bubble_ds/assets/animations/lottie/loading_lottie.json": "2b9a536176f9e8b9e735d6de7f35559a",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"assets/AssetManifest.bin": "aa2bb6d635105e975985676714556442",
"assets/fonts/MaterialIcons-Regular.otf": "bc9d2b38a7163172f73f39b565e2083a",
"assets/assets/images/wavy_gradient_warm.png": "d9ba2d85f9cdc7243af2edf420c68bf9",
"assets/assets/images/IxBuddy.svg": "1f4f4c46464cde93f76febc33a2674a2",
"assets/assets/icons/IxBuddy.original.svg": "cdaedd9c91d5a15a318c8769baa7d4ec",
"assets/assets/icons/IxBuddy.svg": "7e2a5ca2eca02ad7a18ffb3421f57459",
"assets/assets/icons/betteflies-graphic.svg": "cad59e2699c4d93f629d4b48e6d8f186",
"canvaskit/skwasm.js": "1ef3ea3a0fec4569e5d531da25f34095",
"canvaskit/skwasm_heavy.js": "413f5b2b2d9345f37de148e2544f584f",
"canvaskit/skwasm.js.symbols": "0088242d10d7e7d6d2649d1fe1bda7c1",
"canvaskit/canvaskit.js.symbols": "58832fbed59e00d2190aa295c4d70360",
"canvaskit/skwasm_heavy.js.symbols": "3c01ec03b5de6d62c34e17014d1decd3",
"canvaskit/skwasm.wasm": "264db41426307cfc7fa44b95a7772109",
"canvaskit/chromium/canvaskit.js.symbols": "193deaca1a1424049326d4a91ad1d88d",
"canvaskit/chromium/canvaskit.js": "5e27aae346eee469027c80af0751d53d",
"canvaskit/chromium/canvaskit.wasm": "24c77e750a7fa6d474198905249ff506",
"canvaskit/canvaskit.js": "140ccb7d34d0a55065fbd422b843add6",
"canvaskit/canvaskit.wasm": "07b9f5853202304d3b0749d9306573cc",
"canvaskit/skwasm_heavy.wasm": "8034ad26ba2485dab2fd49bdd786837b"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
