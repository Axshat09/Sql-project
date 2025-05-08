# -- Create Database
CREATE DATABASE project_HeartfeltCinema;
USE project_HeartfeltCinema;

# -- Table for Genres
CREATE TABLE Genres (
    genre_id INT PRIMARY KEY AUTO_INCREMENT,
    genre_name VARCHAR(50) NOT NULL
);

# -- Table for Directors
CREATE TABLE Directors (
    director_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    birth_year INT
);

# -- Table for Actors
CREATE TABLE Actors (
    actor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    birth_year INT
);

# -- Table for Movies
CREATE TABLE Movies (
    movie_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100) NOT NULL,
    release_year INT,
    duration_minutes INT,
    genre_id INT,
    director_id INT,
    synopsis TEXT,
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id),
    FOREIGN KEY (director_id) REFERENCES Directors(director_id)
);

# -- Table for Movie Cast
CREATE TABLE Cast (
    movie_id INT,
    actor_id INT,
    role_name VARCHAR(100),
    PRIMARY KEY (movie_id, actor_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id),
    FOREIGN KEY (actor_id) REFERENCES Actors(actor_id)
);

# -- Table for Users
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE	
);



# -- Table for Rating

CREATE TABLE Ratings (
    rating_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    movie_id INT,
    rating DECIMAL(3,1) CHECK (rating BETWEEN 0 AND 10),
    rating_date DATE DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

# -- Table for Reviews
CREATE TABLE Reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    movie_id INT,
    review_text TEXT,
    review_date DATE DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);


# -- Table for Favorites
CREATE TABLE Favorites (
    user_id INT,
    movie_id INT,
    PRIMARY KEY (user_id, movie_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id)
);

# -- Insert Genres
INSERT INTO Genres (genre_name) VALUES
('Romantic Fantasy'),
('Epic Romance'),
('Forbidden Love'),
('Second Chance Romance'),
('Dramatic Devotion'),
('Love Triangle');

# -- Insert Directors
INSERT INTO Directors (name, birth_year) VALUES
('Imtiaz Ali', 1971),
('Sanjay Leela Bhansali', 1963),
('Kunal Deshmukh', 1982),
('Mohit Suri', 1981),
('Rajkumar Hirani', 1962),
('Anurag Basu', 1974),
('Sooraj Barjatya', 1964);

# -- Insert Actors
INSERT INTO Actors (name, birth_year) VALUES
('Ranbir Kapoor', 1982),
('Avinash Tiwary', 1985),
('Shahid Kapoor', 1981),
('Emraan Hashmi', 1979),
('Harshvardhan Rane', 1983),
('Sidharth Malhotra', 1985);

# -- Insert Movies
INSERT INTO Movies (title, release_year, duration_minutes, genre_id, director_id, synopsis) VALUES
('Rockstar', 2011, 159, 4, 3, 'A musician’s journey through love, heartbreak, and self-discovery.'),
('Laila Majnu', 2018, 139, 3, 4, 'A modern retelling of the legendary love story of Laila and Majnu.'),
('Jab We Met', 2007, 138, 3, 2, 'A spontaneous girl and a heartbroken man embark on a life-changing journey.'),
('Jannat', 2008, 140, 5, 6, 'A gambler’s life takes a turn when he falls in love.'),
('Sanam Teri Kasam', 2016, 154, 3, 5, 'A tragic love story between two individuals from different worlds.'),
('Hasee Toh Phasee', 2014, 141, 3, 7, 'A quirky love story between an unconventional girl and a confused man.');

# -- Insert Cast
INSERT INTO Cast (movie_id, actor_id, role_name) VALUES
(1, 1, 'Janardhan "Jordan" Jakhar'),
(2, 2, 'Qais Bhatt (Majnu)'),
(3, 3, 'Aditya Kashyap'),
(4, 4, 'Arjun Dixit'),
(5, 5, 'Inder Lal Parihaar'),
(6, 6, 'Nikhil Bharadwaj');

# -- Insert Users
INSERT INTO Users (username, email) VALUES
('akshat_p', 'axat123@gmail.com'),
('vedant_n', 'vex69@gmail.com'),
('cinebuff', 'cinebuff@gmail.com'),
('moviefanatic', 'fan@gmail.com'),
('bollywoodlover', 'bolly@gmail.com'),
('harsh69', 'harxh77@gmail.com');

# -- Insert Ratings
INSERT INTO Ratings (user_id, movie_id, rating, rating_date) VALUES
(1, 1, 9.5, '2025-05-05'),
(2, 2, 8.9, '2025-05-05'),
(3, 3, 7.8, '2025-05-03'),
(4, 4, 8.2, '2025-05-03');

# -- Insert Reviews
INSERT INTO Reviews (user_id, movie_id, review_text, review_date) VALUES
(1, 1, 'Amazing storytelling and music.', '2025-05-05'),
(2, 2, 'Heartbreaking and beautiful.', '2025-05-05'),
(3, 3, 'A refreshing journey full of surprises.', '2025-05-03'),
(4, 4, 'Gripping narrative and stellar acting.', '2025-05-03'),
(5, 5, 'Beautiful cinematography and touching love story.', '2025-05-04');

# -- Insert Favorites
INSERT INTO Favorites (user_id, movie_id) VALUES 
(1, 2),
(5, 3), 
(3, 5),
(4, 6),
(6, 1),
(2, 4);


# -- Top-rated romantic movies
SELECT M.title, AVG(R.rating) AS avg_rating
FROM Movies M
JOIN Ratings R ON M.movie_id = R.movie_id
GROUP BY M.title
ORDER BY avg_rating DESC
LIMIT 10;

# -- Movies by genre
SELECT G.genre_name, M.title, M.release_year
FROM Movies M
JOIN Genres G ON M.genre_id = G.genre_id
ORDER BY G.genre_name, M.release_year DESC;

# -- Most loved directors
SELECT D.name, COUNT(DISTINCT R.movie_id) AS movie_count
FROM Directors D
JOIN Movies M ON D.director_id = M.director_id
JOIN Ratings R ON M.movie_id = R.movie_id
GROUP BY D.name
ORDER BY movie_count DESC
LIMIT 5;

# -- Users with the most favorites
SELECT U.username, COUNT(F.movie_id) AS favorite_count
FROM Favorites F
JOIN Users U ON F.user_id = U.user_id
GROUP BY U.username
ORDER BY favorite_count DESC
LIMIT 5;

# -- Average ratings by genre
SELECT G.genre_name, AVG(R.rating) AS avg_genre_rating
FROM Movies M
JOIN Genres G ON M.genre_id = G.genre_id
JOIN Ratings R ON M.movie_id = R.movie_id
GROUP BY G.genre_name
ORDER BY avg_genre_rating DESC;

# -- Create View for Top-rated Romantic Movies
CREATE VIEW TopRatedRomance AS
SELECT M.title, AVG(R.rating) AS avg_rating
FROM Movies M
JOIN Ratings R ON M.movie_id = R.movie_id
GROUP BY M.title
ORDER BY avg_rating DESC;

#-- Trigger to auto-fill rating_date if NULL
DELIMITER $$

CREATE TRIGGER set_rating_date BEFORE INSERT ON Ratings
FOR EACH ROW
BEGIN
    IF NEW.rating_date IS NULL THEN
        SET NEW.rating_date = CURDATE();
    END IF;
END $$

DELIMITER ;

#-- Trigger to auto-fill review_date if NULL
DELIMITER $$
CREATE TRIGGER set_review_date BEFORE INSERT ON Reviews
FOR EACH ROW
BEGIN
    IF NEW.review_date IS NULL THEN
        SET NEW.review_date = CURDATE();
    END IF;
END $$
DELIMITER ;


# -- Sample Stored Procedure to Add Favorite
DELIMITER $$
CREATE PROCEDURE AddFavorite(IN uid INT, IN mid INT)
BEGIN
    INSERT INTO Favorites (user_id, movie_id)
    VALUES (uid, mid);
END $$
DELIMITER ;

CREATE INDEX idx_movies_genre ON Movies (genre_id);
CREATE INDEX idx_users_email ON Users (email);


