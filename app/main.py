from flask import Flask, request, jsonify


app = Flask(__name__)


# Stockage temporaire (mémoire)
todos = []


# GET /todos
@app.route("/todos", methods=["GET"])
def get_todos():
    return jsonify(todos), 200


# POST /todos
@app.route("/todos", methods=["POST"])
def add_todo():
    data = request.get_json()

    if not data or "task" not in data:
        return {"error": "Invalid input"}, 400

    todos.append(data)
    return jsonify(data), 201


# DELETE /todos/<id>
@app.route("/todos/<int:index>", methods=["DELETE"])
def delete_todo(index):
    if index < len(todos):
        return jsonify(todos.pop(index)), 200
    return {"error": "Not found"}, 404


# Health check (CRUCIAL pour Kubernetes)
@app.route("/health")
def health():
    return {"status": "ok"}, 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)


