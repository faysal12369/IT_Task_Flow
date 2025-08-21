<?php
$message = '';
$message_type = 'error';
if (isset($_POST['submit'])) {
    $username = $_POST['username'];
    $new_password = $_POST['password'];

    // --- 1. Validation ---
    if (empty($username) || empty($new_password)) {
        $message = "Veuillez remplir le nom d'utilisateur et le nouveau mot de passe.";
    } elseif (strlen($new_password) < 6) {
        $message = "Le mot de passe doit contenir au moins 6 caractères.";
    } else {
        try {
            $connexion = new PDO("mysql:host=localhost;dbname=inv", "root", "");
            $connexion->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);         
            $hashedPassword = password_hash($new_password, PASSWORD_DEFAULT);
            $sql = "UPDATE users SET Password = ?, passbh = ? WHERE Username = ?";
            $stmt = $connexion->prepare($sql);
            $stmt->execute([$hashedPassword, $new_password, $username]);

            if ($stmt->rowCount() > 0) {
                $message_type = 'success';
                $message = "Le mot de passe pour l'utilisateur '" . htmlspecialchars($username) . "' a été changé avec succès !";
            } else {
                $message_type = 'error';
                $message = "Aucun utilisateur trouvé avec ce nom d'utilisateur.";
            }
        } catch (PDOException $e) {
            $message_type = 'error';
            $message = "Erreur de base de données : " . $e->getMessage();
        }
    }
}
?>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Mot de passe oublié</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@300..700&display=swap">
    <link rel="shortcut icon" href="sinal-logo.ico" type="image/x-icon">
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { display: flex; justify-content: center; align-items: center; min-height: 100vh; font-family: 'Inter', sans-serif; background: linear-gradient(135deg, #2c3e50, #1e2028); color: #f0f0f0; padding: 1rem; }
        .form-container { width: 100%; max-width: 480px; border-radius: 1rem; background-color: #1e2028; padding: 3rem; box-shadow: 0 15px 30px rgba(0, 0, 0, 0.5); text-align: center; }
        .logo-title { display: flex; flex-direction: column; align-items: center; margin-bottom: 1.5rem; }
        .logo-title img { width: 70px; margin-bottom: 0.75rem; }
        .logo-title h2 { font-size: 1.4rem; font-weight: 600; margin: 0; color: #a78bfa; }
        .title { font-size: 2rem; font-weight: bold; margin-bottom: 0.5rem; }
        .subtitle { font-size: 1rem; color: #ccc; margin-bottom: 1.5rem; }
        .message-box { border-radius: 0.375rem; padding: 1rem; margin-bottom: 1.5rem; font-size: 1rem; }
        .message-box.success { color: #c8e6c9; background-color: rgba(76, 175, 80, 0.15); border: 1px solid rgba(76, 175, 80, 0.3); }
        .message-box.error { color: #ffcdd2; background-color: rgba(229, 57, 53, 0.15); border: 1px solid rgba(229, 57, 53, 0.3); }
        .input-group { text-align: left; margin-bottom: 1.25rem; }
        .input-group label { font-size: 1rem; color: #ccc; display: block; margin-bottom: 0.5rem; }
        .input-group input { width: 100%; border-radius: 0.375rem; border: 1px solid #4a4a5a; background-color: #2d2f3a; padding: 1rem 1.1rem; color: white; font-size: 1rem; outline: none; }
        .sign { width: 100%; background-color: #a78bfa; color: #1e2028; padding: 1rem; border: none; border-radius: 0.375rem; font-weight: 600; font-size: 1.2rem; cursor: pointer; margin-top: 0.5rem; }
        .back-link { margin-top: 2rem; }
        .back-link a { color: #a78bfa; text-decoration: none; font-size: 0.9rem; }
    </style>
</head>
<body>
    <div class="form-container">
        <div class="logo-title">
            <img src="sinal logo.png" alt="Logo">
            <h2>IT Taskflow</h2>
        </div>
        <p class="title">Réinitialiser le mot de passe</p>
        <p class="subtitle">Entrez le nom d'utilisateur et le nouveau mot de passe.</p>

        <?php if ($message): ?>
            <div class="message-box <?= htmlspecialchars($message_type) ?>"><?= htmlspecialchars($message) ?></div>
        <?php endif; ?>

        <form class="form" method="POST" action="">
            <div class="input-group">
                <label for="username">Nom d'utilisateur</label>
                <input type="text" name="username" id="username" placeholder="Entrez le nom d'utilisateur à modifier" required>
            </div>
            <div class="input-group">
                <label for="password">Nouveau mot de passe</label>
                <input type="password" name="password" id="password" placeholder="Entrez le nouveau mot de passe" required>
            </div>
            <button class="sign" type="submit" name="submit">Changer le mot de passe</button>
        </form>
        <div class="back-link">
            <a href="index.php">Retour à la connexion</a>
        </div>
    </div>
</body>
</html>
