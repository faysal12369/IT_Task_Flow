const mysql = require("mysql");
const express = require("express");
const bodyParser = require("body-parser");
const bcrypt = require("bcrypt");  
const app = express();

// Create MySQL connection
const connection = mysql.createConnection({
    host: "localhost",
    user: "root",
    password: "root",
    database: "nodejs",
    port: 3306
});

// Connect to the database
connection.connect(function (error) {
    if (error) {
        throw error;
    } else {
        console.log("Connexion à la base de données réussie!");
    }
});

// Middleware to parse form data (for POST requests)
app.use(bodyParser.urlencoded({ extended: true }));

// Register route - insert users into the database
app.post("/register", async (req, res) => {
    try {
        const { user_name, user_pass } = req.body;

        // Hash the password before saving it to the database
        const hashedPassword = await bcrypt.hash(user_pass, 10);

        // Insert the new user into the database
        const query = "INSERT INTO loginuser (user_name, user_pass) VALUES (?, ?)";
        connection.query(query, [user_name, hashedPassword], function (error, result) {
            if (error) {
                console.error(error);
                res.status(500).send("Database error");
                return;
            }
            res.redirect("/index");
        });
    } catch (error) {
        console.error(error);
        res.status(500).send("Server error");
    }
});

// Serve the HTML page on GET request
app.get("/", function (req, res) {
    res.sendFile(__dirname + "/index.html");
});

// Handle the login form submission (POST request)
app.post("/", function (req, res) {
    const { user_name, user_pass } = req.body; // Get form data

    // Query the database for the username and password
    connection.query("SELECT * FROM loginuser WHERE user_name = ?", [user_name], async function (error, result, fields) {
        if (error) {
            console.error(error);
            res.status(500).send("Database error");
            return;
        }

        // If the user exists, compare the hashed passwords
        if (result.length > 0) {
            const user = result[0];
            const isPasswordCorrect = await bcrypt.compare(user_pass, user.user_pass);

            if (isPasswordCorrect) {
                res.redirect("/success");
            } else {
                res.redirect("/");
            }
        } else {
            res.redirect("/");
        }
    });
});

// Success route
app.get("/success", function (req, res) {
    res.send("Login successful!"); // You can replace this with a proper success page.
});

// Set app port to avoid conflict with MySQL port
app.listen(3000, () => {
    console.log("Server is running on http://localhost:3000");
});


// function loginFunction() {
//     var username = document.querySelector(".us").value;
//     var password = document.querySelector(".ss").value;
//     if (username === "fayçal" && password === "1234567") {
//         window.location.assign("index.html");
//     } else {
//         console.error("Le Mot De Passe ou Le Nom d'utilisateur est incorrect!");
//     }
// }
