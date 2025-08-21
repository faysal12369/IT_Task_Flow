<?php
$servername = "localhost";
$username = "root";
$password = "root";
$database = "inv";


// Connexion à la base de données
$connection = new mysqli($servername, $username, $password, $database);

// Vérification de la connexion
if ($connection->connect_error) {
    die("Connexion échouée : " . $connection->connect_error);
}

if (isset($_POST['input'])) {
    $input = $_POST['input'];
    $query = "SELECT * FROM users WHERE Username LIKE '{$input}%' OR ID_De_Compte LIKE '{$input}%'";
    $result = mysqli_query($connection, $query);

    if ($result->num_rows > 0) {
        echo '
        <button type="button" class="add_acc" onclick="show()">Ajouter Un Compte</button>
        <table class="t1">
            <thead>
                <tr>
                    <th>ID_De_Compte</th>
                    <th>Nom_Complet</th>
                    <th>Username</th>
                    <th>Email</th>
                    <th>Date D_Integration</th>
                    <th>Permission</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>';

        while ($row = $result->fetch_assoc()) {
            $id = $row['ID_De_Compte'];
            $nom = $row['Nom_Complet'];
            $user = $row['Username'];
            $em = $row['Email'];
            $date = $row['Date_D_Integration'];
            $per = $row['Permission'];

            echo "<tr>
            <td>" . $row['ID_De_Compte'] . "</td>
            <td contenteditable='true' id='editNom_Complet" . $row['ID_De_Compte'] . "'>" . $row['Nom_Complet'] . "</td>
            <td contenteditable='true' id='editUsername" . $row['ID_De_Compte'] . "'>" . $row['Username'] . "</td>
            <td contenteditable='true' id='editEmail" . $row['ID_De_Compte'] . "'>" . $row['Email'] . "</td>
            <td contenteditable='true' id='editDate" . $row['ID_De_Compte'] . "'>" . $row['Date_D_Integration'] . "</td>
            <td contenteditable='true' id='editPermission" . $row['ID_De_Compte'] . "'>" . $row['Permission'] . "</td>
            <td>
            <button type='button' onclick='saveChanges(" . $row['ID_De_Compte'] . ") '>
            <span class='material-symbols-rounded'>edit</span>
            </button>
            <button type='button' onclick='DeleteChanges(" . $row['ID_De_Compte'] . ")'>
            <span class='material-symbols-rounded'>delete</span>
            </button>
            </td>
        </tr>";
        }

        echo "</tbody></table>";

    } else {
        echo "<h6 class='text-center mt-3'>Il n'y a pas de données disponibles</h6>";
    }
    echo '<!-- Ajouter un nouveau compte  -->
                <div class="add" style="display: none;">
                    <form action="account.php" method="POST">
                        <div class="table01">
                            <h3>Ajouter un nouveau compte</h3>
                            <input type="text" name="Nom_Complet" placeholder="Nom Complet" required>
                            <input type="text" name="Username" placeholder="Username" required>
                            <input type="email" name="Email" placeholder="Email" required>
                            <input type="password" name="Password" placeholder="Password" required>
                            <input type="date" name="Date_D_Integration" required>
                            <select name="Permission">
                                <option value="admin">administrateur</option>
                                <option value="Mod">modérateur</option>
                                <option value="Standard">compte standard</option>
                            </select>
                        </div>
                        <button type="submit" class="add_acc" name="ajouter_compte">Ajouter </button>
                        <button type="button" class="ext" onclick="exit()">Fermer </button>
                </div>
                </form>
            </div>
        </div>
    </div>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        // Show Function
        var table = document.querySelector(".t1");
        var table2 = document.querySelector(".add");
        var display = 0;

        function show() {
            if (display == 0) {
                table.style.display = "none";
                table2.style.display = "grid";
                display = 1;
            } else {

                table.style.display = "table";
                table2.style.display = "none";
                display = 0;
            }
        } 
             // modifié les changements! 
        function saveChanges(userId) {
            var Nom_Complet = $("#editNom_Complet" + userId).text();
            var Username = $("#editUsername" + userId).text();
            var Email = $("#editEmail" + userId).text();
            var Date_Integration = $("#editDate" + userId).text();
            var Permission = $("#editPermission" + userId).text();

            $.ajax({
                url: "edit.php",
                type: "POST",
                data: {
                    user_id: userId,
                    Nom_Complet: Nom_Complet,
                    Username: Username,
                    Email: Email,
                    Date_Integration: Date_Integration,
                    Permission: Permission
                },
                success: function (response) {

                    location.reload();
                },
                error: function (xhr, status, error) {
                    console.log("Error:", error);
                }
            });
        }
        // Effacé les données! 
        function DeleteChanges(userId) {
            $.ajax({
                url: "delete.php",
                type: "POST",
                data: {
                    user_id: userId
                },
                success: function (response) {
                    console.log("Deleted successfully");
                    location.reload();
                },
                error: function (xhr, status, error) {
                    console.log("Error!", error);
                }
            });
        }
            </script>';
}
