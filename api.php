<?php
header("Content-Type: application/json");
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

// Handle OPTIONS request for CORS preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    header("HTTP/1.1 200 OK");
    exit();
}

$dsn = 'mysql:host=localhost;dbname=task_manager';
$username = 'root';
$password = '';

try {
    $pdo = new PDO($dsn, $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    $method = $_SERVER['REQUEST_METHOD'];
    $input = json_decode(file_get_contents("php://input"), true);

    switch ($method) {
        case 'GET':
            getTasks($pdo);
            break;
        case 'POST':
            createTask($pdo, $input);
            break;
        case 'PUT':
            updateTask($pdo, $input);
            break;
        case 'DELETE':
            deleteTask($pdo);
            break;
        default:
            echo json_encode(['error' => 'Invalid request method']);
    }

} catch (PDOException $e) {
    echo json_encode(['error' => $e->getMessage()]);
}

function getTasks($pdo) {
    $stmt = $pdo->query("SELECT * FROM tasks");
    $tasks = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($tasks);
}

function createTask($pdo, $input) {
    if (empty($input['title']) || empty($input['description'])) {
        echo json_encode(['error' => 'Title and description are required']);
        return;
    }

    $sql = "INSERT INTO tasks (title, description) VALUES (:title, :description)";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['title' => $input['title'], 'description' => $input['description']]);
    echo json_encode(['message' => 'Task created']);
}

function updateTask($pdo, $input) {
    if (empty($input['id']) || empty($input['title']) || empty($input['description']) || empty($input['status'])) {
        echo json_encode(['error' => 'All fields are required']);
        return;
    }

    $sql = "UPDATE tasks SET title = :title, description = :description, status = :status WHERE id = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute([
        'title' => $input['title'],
        'description' => $input['description'],
        'status' => $input['status'],
        'id' => $input['id']
    ]);
    echo json_encode(['message' => 'Task updated']);
}

function deleteTask($pdo) {
    if (!isset($_GET['id'])) {
        echo json_encode(['error' => 'No task ID provided']);
        return;
    }

    $id = $_GET['id'];
    $sql = "DELETE FROM tasks WHERE id = :id";
    $stmt = $pdo->prepare($sql);
    $stmt->execute(['id' => $id]);
    echo json_encode(['message' => 'Task deleted']);
}
?>
