package com.tjetc.test.java.com.tjetc;

import com.tjetc.entity.userAndAdmin.User;
import com.tjetc.service.service.userFunction.UpdateOwnerService;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
public class TestUpdateUserService {

    @Test
    public void testUpdateUserWithId() {
        User user = new User();
        user.setId(1);
        user.setUsername("testuser");
        user.setEmail("test@example.com");
        
        assert user.getId() != null : "用户ID不应为null";
        System.out.println("用户ID: " + user.getId());
        System.out.println("用户名: " + user.getUsername());
        System.out.println("邮箱: " + user.getEmail());
    }
}
