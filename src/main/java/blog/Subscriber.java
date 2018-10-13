package blog;

import com.google.appengine.api.users.User;
import com.googlecode.objectify.Key;
import com.googlecode.objectify.annotation.Entity;
import com.googlecode.objectify.annotation.Id;
import com.googlecode.objectify.annotation.Index;
import com.googlecode.objectify.annotation.Parent;

@Entity
public class Subscriber {

    @Parent Key<Subscription> subList;
	@Id Long id;
    @Index User user;
    
    Boolean subscribed;

    @SuppressWarnings("unused")
	public Subscriber() {

	}
    
    public Subscriber(User user, String subList) {
    	this.subList = Key.create(Subscription.class, subList);
    	this.user = user;
    	subscribed = true;
    }
    
    public Boolean isSubscribed() {
    	return subscribed;
    }
    
    public void subscribe() {
    	subscribed = true;
    }
    
    public void unsubscribe() {
    	subscribed = false;
    }
    
    public void toggleSubscription() {
    	subscribed = !subscribed;
    }
    
    public User getUser() {
    	return user;
    }

}

