package dao;

import model.User;
import java.util.List;

public interface UserDAO {
    List<User> getAllUsers();
    User getUserById(int id);
    User getUserByEmail(String email);
    boolean addUser(User user);
    boolean updateUser(User user);
    boolean deleteUser(int id);
}
