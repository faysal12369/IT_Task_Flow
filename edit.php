<?php
if (isset($_POST['user_id'])) {
    $user_id = $_POST['user_id'];
    $Nom_Complet = $_POST['Nom_Complet'];
    $Username = $_POST['Username'];
    $Email = $_POST['Email'];
    $Date_Integration = $_POST['Date_Integration'];
    $Permission = $_POST['Permission'];

    // Database connection
    $servername = "localhost";
    $username = "root";
    $password = "root";
    $database = "inv";

    // Create connection
    $connection = new mysqli($servername, $username, $password, $database);

    // Vérification de la connexion
    if ($connection->connect_error) {
        die("Connexion échouée : " . $connection->connect_error);
    }

    // Update user in the database
    $sql = "UPDATE users SET Nom_Complet = ?, Username = ?, Email = ?, Date_D_Integration = ?, Permission = ? WHERE ID_De_Compte = ?";
    $prp = $connection->prepare($sql);

    // Use 's' for string types and 'i' for integer types in bind_param
    $prp->bind_param("sssssi",$Nom_Complet, $Username, $Email, $Date_Integration, $Permission, $user_id);
    
    // Execute the query
    $prp->execute();
    $connection->close();
}
?>
