package dao;

import config.DatabaseConfig;
import model.User;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class FileUserDAO implements UserDAO {

    @Override
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();

        // Ensure the file exists
        DatabaseConfig.ensureFileExists(DatabaseConfig.USERS_FILE);

        try (BufferedReader reader = new BufferedReader(new FileReader(DatabaseConfig.USERS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 5) {
                    User user = new User(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        parts[4]
                    );
                    users.add(user);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return users;
    }

    @Override
    public User getUserById(int id) {
        try (BufferedReader reader = new BufferedReader(new FileReader(DatabaseConfig.USERS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 5 && Integer.parseInt(parts[0]) == id) {
                    return new User(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        parts[4]
                    );
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public User getUserByEmail(String email) {
        try (BufferedReader reader = new BufferedReader(new FileReader(DatabaseConfig.USERS_FILE))) {
            String line;
            while ((line = reader.readLine()) != null) {
                String[] parts = line.split("\\|");
                if (parts.length == 5 && parts[2].equals(email)) {
                    return new User(
                        Integer.parseInt(parts[0]),
                        parts[1],
                        parts[2],
                        parts[3],
                        parts[4]
                    );
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        return null;
    }

    @Override
    public boolean addUser(User user) {
        List<User> users = getAllUsers();

        // Check if email already exists
        boolean emailExists = users.stream()
                .anyMatch(u -> u.getEmail().equals(user.getEmail()));

        if (emailExists) {
            return false; // Email already exists
        }

        // Generate a new ID (get the highest ID and add 1)
        int newId = 1; // Default if no users exist

        if (!users.isEmpty()) {
            newId = users.stream()
                    .mapToInt(User::getId)
                    .max()
                    .orElse(0) + 1;
        }

        user.setId(newId);
        users.add(user);

        return saveAllUsers(users);
    }

    @Override
    public boolean updateUser(User user) {
        List<User> users = getAllUsers();
        boolean updated = false;

        // Replace the user with the updated one
        for (int i = 0; i < users.size(); i++) {
            if (users.get(i).getId() == user.getId()) {
                users.set(i, user);
                updated = true;
                break;
            }
        }

        if (updated) {
            return saveAllUsers(users);
        }

        return false;
    }

    @Override
    public boolean deleteUser(int id) {
        List<User> users = getAllUsers();
        boolean removed = users.removeIf(user -> user.getId() == id);

        if (removed) {
            return saveAllUsers(users);
        }

        return false;
    }

    private boolean saveAllUsers(List<User> users) {
        try {
            // Ensure directory exists
            DatabaseConfig.ensureFileExists(DatabaseConfig.USERS_FILE);

            // Write all users to the file
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(DatabaseConfig.USERS_FILE))) {
                for (User user : users) {
                    writer.write(formatUserForFile(user));
                    writer.newLine();
                }
                return true;
            }
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    private String formatUserForFile(User user) {
        return String.format("%d|%s|%s|%s|%s",
                user.getId(),
                user.getName(),
                user.getEmail(),
                user.getPassword(),
                user.getRole());
    }
}
