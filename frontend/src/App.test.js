import React from 'react';
import { render, screen, waitFor, fireEvent } from '@testing-library/react';
import userEvent from '@testing-library/user-event';
import '@testing-library/jest-dom';
import axios from 'axios';
import App from './App';

jest.mock('axios');

const mockTasks = [
  {
    id: 1,
    title: 'Learn React Testing',
    description: 'Study Jest and RTL',
    completed: false,
    created_at: '2023-10-01T12:00:00Z',
  },
  {
    id: 2,
    title: 'Write Unit Tests',
    description: 'Test the App component',
    completed: true,
    created_at: '2023-10-02T12:00:00Z',
  },
];

describe('App Component - Task Manager', () => {
  beforeEach(() => {
    jest.clearAllMocks();
  });

  /* eslint-disable testing-library/no-wait-for-multiple-assertions */

  test('1. Fetches and renders tasks on mount', async () => {
    axios.get.mockResolvedValueOnce({ data: mockTasks });
    
    render(<App />);

    expect(screen.getByText('Task Manager')).toBeInTheDocument();
    
    // FIX: Use getAllByRole because there are multiple progressbars
    expect(screen.getAllByRole('progressbar')[0]).toBeInTheDocument();

    await waitFor(() => {
      expect(screen.getByText('Learn React Testing')).toBeInTheDocument();
    });
    
    await waitFor(() => {
      expect(screen.getByText('Write Unit Tests')).toBeInTheDocument();
    });

    expect(axios.get).toHaveBeenCalledWith('/api/tasks');
    expect(axios.get).toHaveBeenCalledTimes(1);
  });

  test('2. Successfully creates a new task', async () => {
    axios.get.mockResolvedValueOnce({ data: [] });
    axios.post.mockResolvedValueOnce({ data: { message: 'Success' } });
    axios.get.mockResolvedValueOnce({ 
      data: [{ id: 3, title: 'New Task', description: 'New Desc', completed: false, created_at: '2023-10-03T12:00:00Z' }] 
    });

    render(<App />);

    // FIX: Check that the array of progressbars is empty
    await waitFor(() => expect(screen.queryAllByRole('progressbar').length).toBe(0));

    // FIX: Use direct userEvent calls without setup()
    userEvent.type(screen.getByLabelText(/Task Title/i), 'New Task');
    userEvent.type(screen.getByLabelText(/Description/i), 'New Desc');
    userEvent.click(screen.getByRole('button', { name: /Add Task/i }));

    await waitFor(() => {
      expect(axios.post).toHaveBeenCalledWith('/api/tasks', {
        title: 'New Task',
        description: 'New Desc',
      });
    });

    await waitFor(() => {
      expect(screen.getByText('Task created successfully!')).toBeInTheDocument();
    });

    await waitFor(() => {
      expect(screen.getByText('New Task')).toBeInTheDocument();
    });
  });

  test('3. Toggles task completion status', async () => {
    axios.get.mockResolvedValueOnce({ data: [mockTasks[0]] });
    axios.put.mockResolvedValueOnce({ data: { message: 'Updated' } });
    axios.get.mockResolvedValueOnce({ data: [{ ...mockTasks[0], completed: true }] });

    render(<App />);

    const checkbox = await screen.findByRole('checkbox');
    expect(checkbox).not.toBeChecked();

    fireEvent.click(checkbox);

    await waitFor(() => {
      expect(axios.put).toHaveBeenCalledWith(`/api/tasks/1`, {
        ...mockTasks[0],
        completed: true,
      });
    });
  });

  test('4. Opens edit mode and updates a task', async () => {
    axios.get.mockResolvedValueOnce({ data: [mockTasks[0]] });
    axios.put.mockResolvedValueOnce({ data: { message: 'Updated' } });
    axios.get.mockResolvedValueOnce({ 
      data: [{ ...mockTasks[0], title: 'Updated Title' }] 
    });

    render(<App />);

    await screen.findByText('Learn React Testing');

    const editButton = screen.getByTestId('EditIcon');
    fireEvent.click(editButton);

    const titleInput = screen.getByLabelText(/Task Title/i);
    expect(titleInput.value).toBe('Learn React Testing');

    // FIX: Use direct userEvent calls without setup()
    userEvent.clear(titleInput);
    userEvent.type(titleInput, 'Updated Title');
    userEvent.click(screen.getByRole('button', { name: /Update Task/i }));

    await waitFor(() => {
      expect(axios.put).toHaveBeenCalledWith(`/api/tasks/1`, {
        title: 'Updated Title',
        description: 'Study Jest and RTL',
      });
    });

    await waitFor(() => {
      expect(screen.getByText('Task updated successfully!')).toBeInTheDocument();
    });
  });

  test('5. Deletes a task after confirmation', async () => {
    axios.get.mockResolvedValueOnce({ data: [mockTasks[0]] });
    axios.delete.mockResolvedValueOnce({ data: { message: 'Deleted' } });
    axios.get.mockResolvedValueOnce({ data: [] });

    render(<App />);

    await screen.findByText('Learn React Testing');

    const deleteButton = screen.getByTestId('DeleteIcon');
    fireEvent.click(deleteButton);

    expect(screen.getByText('Confirm Delete')).toBeInTheDocument();
    expect(screen.getByText('Are you sure you want to delete this task?')).toBeInTheDocument();

    const confirmDeleteBtn = screen.getByRole('button', { name: 'Delete' });
    fireEvent.click(confirmDeleteBtn);

    await waitFor(() => {
      expect(axios.delete).toHaveBeenCalledWith(`/api/tasks/1`);
    });

    await waitFor(() => {
      expect(screen.getByText('Task deleted successfully!')).toBeInTheDocument();
    });
  });

  test('6. Displays error snackbar when API call fails', async () => {
    axios.get.mockRejectedValueOnce(new Error('Network Error'));

    render(<App />);

    await waitFor(() => {
      expect(screen.getByText('Failed to fetch tasks. Please try again later.')).toBeInTheDocument();
    });
  });
});