package blog;

import java.util.Date;
import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class Blog implements Comparable<Blog> {
	
    @Parent Key<BlogRecord> blogRecordName;
    @Id Long id;
    @Index User user;
    @Index String title;
    @Index String content;
    @Index Date date;
    
    @SuppressWarnings("unused")
	private Blog() {
    	
    }
    
    public Blog(User user, String title, String content, String blogRecordName) {
        this.user = user;
        this.title = title;
        this.content = content;
        this.blogRecordName = Key.create(BlogRecord.class, blogRecordName);
        date = new Date();
    }
    public User getUser() {
        return user;
    }
	public String getDate() {
    	return date.toString();
    }
    public String getTitle() {
    	return title;
    }
    public String getContent() {
        return content;
    }

    @Override
    public int compareTo(Blog other) {
        if (date.after(other.date)) {
            return -1;
        } else if (date.before(other.date)) {
            return 1;
        }
        return 0;
     }
    
}