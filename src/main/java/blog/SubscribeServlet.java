package blog;

import java.io.IOException;

import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.google.appengine.api.users.UserService;
import com.google.appengine.api.users.UserServiceFactory;
import com.googlecode.objectify.ObjectifyService;

public class SubscribeServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
	
	static {
		ObjectifyService.register(Subscriber.class);
	}
	
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {
		
        UserService userService = UserServiceFactory.getUserService();
        User user = userService.getCurrentUser();
        
		String subList = req.getParameter("subList");
	    if (subList == null) {
	    	subList = "default";
	    }
		Subscriber sub = ObjectifyService.ofy().load().type(Subscriber.class).filter("user", user).first().now();
		if(sub != null) {
			sub.toggleSubscription();
		} else {
			sub = new Subscriber(user, subList);
		}
		ObjectifyService.ofy().save().entity(sub).now();

        resp.sendRedirect("/blog.jsp?subList=" + subList);
	}

}
