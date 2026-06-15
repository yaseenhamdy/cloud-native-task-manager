import pytest
from app import app, db, Task

@pytest.fixture
def client():
    app.config['TESTING'] = True
    app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///:memory:'
    app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

    with app.test_client() as client:
        with app.app_context():
            db.create_all()
            yield client
            db.session.remove()
            db.drop_all()

def test_health_check_simple(client):
    response = client.get('/health/simple')
    assert response.status_code == 200
    assert response.get_json() == {'status': 'ok'}

def test_create_task(client):
    response = client.post('/api/tasks', json={
        'title': 'Test Task',
        'description': 'Test Description'
    })
    assert response.status_code == 201
    data = response.get_json()
    assert data['title'] == 'Test Task'
    assert data['description'] == 'Test Description'
    assert data['completed'] is False

def test_create_task_missing_title(client):
    response = client.post('/api/tasks', json={
        'description': 'Test Description'
    })
    assert response.status_code == 400
    assert 'error' in response.get_json()

def test_get_tasks(client):
    client.post('/api/tasks', json={'title': 'Task 1'})
    client.post('/api/tasks', json={'title': 'Task 2'})

    response = client.get('/api/tasks')
    assert response.status_code == 200
    data = response.get_json()
    
    assert len(data) == 2
    assert data[0]['title'] == 'Task 2'
    assert data[1]['title'] == 'Task 1'

def test_update_task(client):
    post_response = client.post('/api/tasks', json={'title': 'Old Title'})
    task_id = post_response.get_json()['id']

    response = client.put(f'/api/tasks/{task_id}', json={
        'title': 'New Title',
        'completed': True
    })
    assert response.status_code == 200
    data = response.get_json()
    assert data['title'] == 'New Title'
    assert data['completed'] is True

def test_update_task_not_found(client):
    response = client.put('/api/tasks/999', json={'title': 'New Title'})
    assert response.status_code == 404

def test_delete_task(client):
    post_response = client.post('/api/tasks', json={'title': 'To be deleted'})
    task_id = post_response.get_json()['id']

    response = client.delete(f'/api/tasks/{task_id}')
    assert response.status_code == 204

    check_response = client.put(f'/api/tasks/{task_id}', json={'title': 'Check'})
    assert check_response.status_code == 404

def test_delete_task_not_found(client):
    response = client.delete('/api/tasks/999')
    assert response.status_code == 404