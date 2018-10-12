package blog;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

import static com.googlecode.objectify.ObjectifyService.ofy;

import java.io.IOException;
 
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
 
public class WriteBlogServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	static {
		ObjectifyService.register(Blog.class);
	}

	public void doPost(HttpServletRequest req, HttpServletResponse resp)
                throws IOException {
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
 
        // We have one entity group per Guestbook with all Greetings residing
        // in the same entity group as the Guestbook to which they belong.
        // This lets us run a transactional ancestor query to retrieve all
        // Greetings for a given Guestbook.  However, the write rate to each
        // Guestbook should be limited to ~1/second.
        String blogRecordName = req.getParameter("blogRecordName");
        String content = req.getParameter("content");
        Blog blog = new Blog(user, content, blogRecordName);
        ofy().save().entity(blog).now();
 
        resp.sendRedirect("/blog.jsp?blogRecordName=" + blogRecordName);
    }
}