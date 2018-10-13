package blog;

import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;

@Entity
public class Subscription {

	@Id long id;
	String name;

	public Subscription(String name) {
		this.name = name;
	}

}