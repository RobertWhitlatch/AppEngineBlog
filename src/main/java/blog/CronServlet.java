package blog;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.ObjectifyService;

public class CronServlet extends HttpServlet {

	private static final long serialVersionUID = 1L;
	
	@SuppressWarnings("deprecation")
	public void doGet(HttpServletRequest req, HttpServletResponse resp) throws IOException {

		ObjectifyService.register(Subscriber.class);
		ObjectifyService.register(Blog.class);

		List<Blog> blogs = ObjectifyService.ofy().load().type(Blog.class).list();
		Collections.sort(blogs);
		
		if(blogs == null) {
			resp.setStatus(240);
			return;
		}

		SimpleDateFormat fmt = new SimpleDateFormat("yyyyMMdd");
		Blog mostRecent = ObjectifyService.ofy().load().type(Blog.class).first().now();
		Date newest = mostRecent.getDateObject();
		String newestString = fmt.format(newest);		
		Date now = new Date();
		Date limit = new Date();
		limit.setDate(limit.getDate() - 1);
		String nowString = fmt.format(now);
		if(newestString == nowString) {
			resp.setStatus(241);
			return;
		}
		
		StringBuilder sb = new StringBuilder();
		sb.append("Here is what has been talked about since yesterday...\n\r\n\r");
		for(Blog blog : blogs) {
			if(limit.before(blog.getDateObject())) {
				if(blog.getTitle() == null) {
					continue;
				}
				if(blog.getContent() == null) {
					continue;
				}
				if(blog.getDate() == null) {
					continue;
				}
				sb.append(blog.getTitle() + "\n\r");
				sb.append(blog.getContent() + "\n\r");
				sb.append("Posted by " + blog.getUser().getNickname() + " at " + blog.getDate().toString() + ".\n\r\n\r");
			} else {
				break;
			}
		}
		
		List<Subscriber> subs = ObjectifyService.ofy().load().type(Subscriber.class).list();
		
		if(subs == null) {
			resp.setStatus(242);
		}
		
		for(Subscriber sub : subs) {
			if(!sub.isSubscribed() || sub.getUser().getEmail() == null) {
				continue;
			}
			Properties props = new Properties();
			Session session = Session.getDefaultInstance(props, null);
			Message msg = new MimeMessage(session);
			try {
				msg.setFrom(new InternetAddress("noreply@mitchandsummerblog.appspotmail.com"));
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(sub.getUser().getEmail()));
				msg.setSubject("There have been new posts!");
				String body = sb.toString();
				msg.setText(body);
				Transport.send(msg);
			} catch (Exception ex)  {
				
			}
		}
		resp.setStatus(247);
	}
	
}
