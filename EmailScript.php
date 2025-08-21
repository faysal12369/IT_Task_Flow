<?php
// Include PHPMailer's required classes
require 'C:/laragon/www/reminder/phpmailer/Exception.php';
require 'C:/laragon/www/reminder/phpmailer/PHPMailer.php';
require 'C:/laragon/www/reminder/phpmailer/SMTP.php';

// Instantiate PHPMailer
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;

// Your existing code for handling the task and sending an email
if (isset($_POST['Idt'])) {
    $tache_id = $_POST['Idt'];
    $name_tache = $_POST['Nt'];
    $start_date = $_POST['DD'];
    $fin_date = $_POST['FD'];
    $fou = $_POST['Fou'];
    $divi = $_POST['Div'];
    $adrs = $_POST['Adr'];
    $com = $_POST['Com'];

    // Database connection
    $servername = "localhost";
    $username = "root";
    $password = "root";
    $database = "tasks";

    // Create connection
    $connection = new mysqli($servername, $username, $password, $database);

    // Vérification de la connexion
    if ($connection->connect_error) {
        die("Connexion échouée : " . $connection->connect_error);
    }

    $query = $connection->query("SELECT * FROM task WHERE task_id = ?");
    $stmt = $connection->prepare($query);
    $stmt->bind_param('i', $tache_id);
    $stmt->execute();
    
    $result = $stmt->get_result();

    if ($result && $result->num_rows > 0) {
        $row = $result->fetch_assoc();
        $end_date = new DateTime($fin_date);

        $today = new DateTime();

        $diff = $today->diff($end_date);

        if ($diff->days == 15 && $diff->invert == 0) {
            // Prepare PHPMailer
            $mail = new PHPMailer();

            $mail->isSMTP();  
            $mail->Host = 'smtp.gmail.com';  
            $mail->SMTPAuth = true;  
            $mail->Username = 'sinaltest25@gmail.com';  
            $mail->Password = '2022Sin@l';  
            $mail->Port = 587;            

            // Recipients
            $mail->setFrom('sinaltest25@gmail.com', 'Faysal');
            $mail->addAddress('gheroufellafaycal@gmail.com');


            $mail->isHTML(true);                                       
            $mail->Subject = 'Rappel: 15 Jours Restants!';
            $mail->Body    = "Veuillez consulter la tâche: $name_tache";

            // Send email
            if ($mail->send()) {
                echo 'Reminder email sent successfully.';
            } else {
                echo 'Failed to send reminder email. Error: ' . $mail->ErrorInfo;
            }
        }
    } else {
        echo 'No task found for the given ID.';
    }

    $stmt->close();
}

?>
