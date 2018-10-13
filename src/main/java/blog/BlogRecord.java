package blog;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class BlogRecord {
	
    @Id long id;
    String name;

    public BlogRecord(String name) {
        this.name = name;
    }

}