<?php
require('vendor/autoload.php');
use Firebase\JWT\JWT;
use Firebase\JWT\Key;

session_start();

$erreur = '';

if (isset($_POST['submit'])) {
    try {
        $connexion = new PDO("mysql:host=localhost;dbname=inv", "root", "");
        $connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    } catch(PDOException $e) {
        $erreur = "Erreur de connexion à la base de données.";
    }

    if ($erreur === '') {
        if (empty($_POST['username'])) {
            $erreur = "Veuillez entrer le nom d'utilisateur.";
        } elseif (empty($_POST['password'])) {
            $erreur = "Veuillez entrer le mot de passe.";
        } else {
            $checkUser = $connexion->prepare("SELECT * FROM users WHERE Username = ?");
            $checkUser->execute([$_POST['username']]);
            $user = $checkUser->fetch(PDO::FETCH_ASSOC);

            if ($user && password_verify($_POST['password'], $user['Password'])) {
                $rememberMe = isset($_POST['remember']);
                $cookie_expiration_time = $rememberMe ? time() + (86400 * 30) : time() + 3600;

                $key = 'sinal';
                $payload = [
                    'iat' => time(),
                    'nbf' => time(),
                    'exp' => $cookie_expiration_time,
                    'data' => [
                        'id' => $user['ID_De_Compte'] ?? $user['id'],
                        'nom' => $user['Username'],
                        'per' => $user['Permission'],
                        'nam' => $user['Nom_Complet']
                    ]
                ];

                $token = JWT::encode($payload, $key, 'HS256');

                // 3. Set the cookie with the dynamic expiration time
                setcookie("token", $token, $cookie_expiration_time, "/", "", true, true);

                header("Location: main.php");
                exit;

            } else {
                $erreur = "Nom d'utilisateur ou mot de passe incorrect.";
            }
        }
    }
}
?>

<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <title>Connexion</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.3.0/css/all.min.css" />
  <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300..700&display=swap">
    <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
    <style>
    /* --- General Reset & Body Styles --- */
    * {
        box-sizing: border-box;
        margin: 0;
        padding: 0;
    }

    body {
        font-family: 'Inter', sans-serif;
        background: linear-gradient(135deg, #2c3e50, #1e2028);
        color: #f0f0f0;
        display: flex;
        justify-content: center;
        align-items: center;
        min-height: 100vh; 
        padding: 1rem;
    }

    /* --- Form Container --- */
    .form-container {
        width: 100%; 
        max-width: 400px;
        border-radius: 1rem;
        background-color: #1e2028;
        padding: 2.5rem;
        box-shadow: 0 15px 30px rgba(0, 0, 0, 0.5);
        text-align: center;
        transition: all 0.3s ease;
    }

    /* --- Logo and Titles --- */
    .logo-title {
        display: flex;
        flex-direction: column;
        align-items: center;
        margin-bottom: 1.5rem;
    }

    .logo-title img {
        width: 60px;
        margin-bottom: 0.75rem;
    }

    .logo-title h2 {
        font-size: 1.25rem;
        margin: 0;
        color: #a78bfa;
        font-weight: 600;
    }

    .title {
        font-size: 1.75rem;
        font-weight: bold;
        margin-bottom: 1.5rem;
    }

    /* --- Error Message --- */
    .message {
        color: #ff6b6b;
        background-color: rgba(255, 107, 107, 0.1);
        border: 1px solid rgba(255, 107, 107, 0.3);
        border-radius: 0.375rem;
        padding: 0.75rem;
        margin-bottom: 1.5rem;
        font-size: 0.9rem;
    }

    /* --- Input Fields & Labels --- */
    .input-group {
        text-align: left;
        margin-bottom: 1.25rem;
    }

    .input-group label {
        font-size: 0.9rem;
        color: #ccc;
        display: block;
        margin-bottom: 0.5rem;
    }

    .input-group input {
        width: 100%;
        border-radius: 0.375rem;
        border: 1px solid #4a4a5a;
        background-color: #2d2f3a;
        padding: 0.85rem 1rem;
        color: white;
        font-size: 1rem;
        outline: none;
        transition: border-color 0.3s ease, box-shadow 0.3s ease;
    }

    .input-group input:focus {
        border-color: #a78bfa;
        box-shadow: 0 0 0 3px rgba(167, 139, 250, 0.3);
    }

    /* --- Remember Me Checkbox --- */
    .remember-me-group {
        display: flex;
        align-items: center;
        text-align: left;
        margin-bottom: 1.5rem;
        font-size: 0.9rem;
    }

    .remember-me-group label {
        color: #ccc;
        cursor: pointer;
        margin-left: 0.5rem;
    }

    .remember-me-group input[type="checkbox"] {
        appearance: none;
        width: 1.2em;
        height: 1.2em;
        border: 2px solid #555;
        border-radius: 0.25rem;
        cursor: pointer;
        position: relative;
        top: 2px;
    }

    .remember-me-group input[type="checkbox"]:checked {
        background-color: #a78bfa;
        border-color: #a78bfa;
    }

    .remember-me-group input[type="checkbox"]:checked::before {
        content: '✔';
        font-size: 0.9em;
        color: #1e2028;
        position: absolute;
        right: 2px;
        top: -1px;
    }

    /* --- Submit Button --- */
    .sign {
        width: 100%;
        background-color: #a78bfa;
        color: #1e2028;
        padding: 0.85rem;
        border: none;
        border-radius: 0.375rem;
        font-weight: 600;
        font-size: 1.1rem;
        cursor: pointer;
        transition: background-color 0.3s ease, transform 0.2s ease;
    }

    .sign:hover {
        background-color: #9975f9;
        transform: translateY(-2px);
    }


.remember-me-container {
    position: relative;
    text-align: left;
    margin-bottom: 1.5rem;
    padding-right: 160px; 
    height: 2em;
    display: flex;
    align-items: center;
}

.remember-me-container label {
    color: #ccc;
    cursor: pointer;
    margin-left: 0.5rem;
    font-size: 0.9rem;
    background: #1e2028;
}

.forgot-link-absolute {
    position: absolute;
    right: 0;
    top: 50%;
    transform: translateY(-50%);
    color: #a78bfa;
    text-decoration: none;
    font-size: 0.9rem;
}

.forgot-link-absolute:hover {
    text-decoration: underline;
}
.forgot-link:hover {
    text-decoration: underline;
}
    @media (min-width: 500px) {
        .form-container {
            max-width: 480px; 
            padding: 3.5rem;
        }

        .logo-title img {
            width: 70px;
        }

        .logo-title h2 {
            font-size: 1.4rem;
        }

        .title {
            font-size: 2rem;
        }

        .input-group label {
            font-size: 1rem;
        }

        .input-group input {
            padding: 1rem 1.1rem;
            font-size: 1rem;
        }
        
        .remember-me-group {
            font-size: 1rem;
        }

        .sign {
            padding: 1rem;
            font-size: 1.2rem;
            margin-top: 0.5rem;
        }
    }
</style>
</head>
<body>
  <div class="form-container">
    <div class="logo-title">
      <img src="sinal logo.png" alt="Logo">
      <h2>IT Taskflow</h2>
    </div>

    <p class="title">Login</p>

    <?php if ($erreur !== ''): ?>
      <div class="message"><?= htmlspecialchars($erreur) ?></div>
    <?php endif; ?>

    <form class="form" method="POST" action="">
      <div class="input-group">
        <label for="username">Nom d'utilisateur</label>
        <input type="text" name="username" id="username" placeholder="Votre nom d'utilisateur" required>
      </div>

      <div class="input-group">
        <label for="password">Mot de passe</label>
        <input type="password" name="password" id="password" placeholder="Votre mot de passe" required>
      </div>
    <div class="options-container">
    <div class="remember-me-container">
    <input type="checkbox" name="remember" id="remember">
    <label for="remember">Se souvenir de moi</label>
    <a href="pass_oublié.php" class="forgot-link-absolute">Mot de passe oublié ?</a>
</div>
      <button class="sign" type="submit" name="submit">Se connecter</button>
    </form>

</body>

</html>
