<?php
include 'db.php';

if ($_SERVER['REQUEST_METHOD'] === 'POST' && !empty($_POST['task'])) {
    $task = $conn->real_escape_string($_POST['task']);
    $status = $conn->real_escape_string($_POST['status']);
    $conn->query("INSERT INTO tasks (task, status) VALUES ('$task', '$status')");
}

header('Location: index.php');
exit;
?>