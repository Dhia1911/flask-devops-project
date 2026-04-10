from app.main import app


def test_get_todos():
    client = app.test_client()
    response = client.get("/todos")
    assert response.status_code == 200


def test_add_todo():
    client = app.test_client()
    response = client.post("/todos", json={"task": "learn devops"})
    assert response.status_code == 201


def test_delete_todo():
    client = app.test_client()
    client.post("/todos", json={"task": "test"})
    response = client.delete("/todos/0")
    assert response.status_code == 200


def test_health():
    client = app.test_client()
    response = client.get("/health")
    assert response.status_code == 200