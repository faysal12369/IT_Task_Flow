<?php
session_start();
include("config.php");

if (isset($_POST['submit'])) {
    //  input to prevent SQL Injection
    $username = mysqli_real_escape_string($co, $_POST['user_name']);
    $password = mysqli_real_escape_string($co, $_POST['user_pass']);
    
    // Fetch user data from the database based on username
    $result = mysqli_query($co, "SELECT * FROM users WHERE Username='$username' AND Password='$password'");
    $row = mysqli_fetch_assoc($result);

    // Check if user exists and verify password
    if ($row) {
        // User is authenticated, store relevant session data
        $_SESSION['valid_username'] = $row['Username'];
        $_SESSION['valid_password'] = $row['Password']; 

        // Redirect to the index page
        header("Location: index.php");
    } else {
        // Invalid credentials
        echo "<div class='message'>
        <p>Nom d'utilisateur ou mot de passe incorrect</p>
        </div> <br>";
        echo "<a href='login-page.php'><button class='btnr'>Revenir</button></a>";
    }
}
?>


<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="/css files/login.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" />
    <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
    <title>Page de Connexion</title>
</head>
<body>
    <div class="container">
        <div class="top">
            <div class="main">
                <img src="sinal logo.png" class="img">
                <h1>IT TaskFlow</h1>
            </div>
            <div class="login-form">
                <div class="login-txt">
                    <h2>Bienvenu</h2>
                    <p>Veuillez entrer vos informations</p> 
                </div>
                <div class="login">
                    <form action="" method="post" class="frm">
                        <div class="int">
                            <label for="username" class="use">Le Nom D'utilisateur</label>
                            <input type="text" class="us" placeholder="Veuillez entré votre Nom D'utilisateur" required name="user_name">
                        </div>
                        <div class="int">
                            <label for="pass" class="pas">Mot de passe</label>
                            <input type="password" class="ss" placeholder="Veuillez Entré Votre Mot De Passe" required name="user_pass">
                        </div>
                        <div class="ff">
                            <input type="checkbox" name="remember-me">
                            <label for="remember-me">Se Souvenir De Moi</label>
                        </div>
                        <div class="btn">
                            <button type="submit" name="submit" class="clkbtn">Se Connécter</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
<script src="login.js"></script>
</html>
