resource "aws_lb_target_group" "target-group" {
    health_check {
      interval = 10
      path = "/"
      protocol = "HTTP"
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
    }   

    name = "TG-EXAMEN-2"
    port = 5000
    protocol = "HTTP"
    target_type = "instance"
    vpc_id = data.aws_vpc.default.id
  
}

#Autoscaling Attachment
resource "aws_autoscaling_attachment" "svc_asg_external2" {
  alb_target_group_arn   = "${aws_lb_target_group.target-group.arn}"
  autoscaling_group_name = "${aws_autoscaling_group.bar.id}"
}

#Load Balancer
resource "aws_lb" "application-lb" {
    name            = "LB-EXAMEN-2"
    internal        = false
    ip_address_type = "ipv4"
    load_balancer_type = "application"
    security_groups = ["sg-028e0d5f7222fc799"]
    subnets = data.aws_subnet_ids.subnet.ids

    tags = {
        Name = "whiz-alb"
    }
  
}
#Listener
resource "aws_lb_listener" "alb-listener" {
    load_balancer_arn = aws_lb.application-lb.arn 
    port              = 80
    protocol          = "HTTP"
    default_action{
        target_group_arn = aws_lb_target_group.target-group.arn 
        type = "forward"
    } 

  
}