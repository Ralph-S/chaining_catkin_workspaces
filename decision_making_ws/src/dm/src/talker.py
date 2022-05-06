#!/usr/bin/env python
# license removed for brevity

import rospy
from parent.msg import myMSG 

def talker():
    pub = rospy.Publisher('/test/topic', myMSG, queue_size=10)
    rospy.init_node('talker', anonymous=True)
    rate = rospy.Rate(0.5) # 2 seconds
    while not rospy.is_shutdown():
        myMessage = myMSG()
        myMessage.name = "PickBot"
        myMessage.age = 2022
        rospy.loginfo(myMessage)
        pub.publish(myMessage)
        rate.sleep()
  
if __name__ == '__main__':
    try:
        talker()
    except rospy.ROSInterruptException:
        pass