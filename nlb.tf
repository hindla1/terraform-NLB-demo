resource "aws_lb" "my-nlb" {
  name               = "my-nlb"
  internal           = false
  load_balancer_type = "network"
  subnets            = [aws_subnet.my-pub-subnet.id]

  enable_deletion_protection = true

  tags = {
    Environment = "demo"
  }
}



resource "aws_lb_target_group" "my-target-grp" {
  name     = "my-target-grp"
  port     = 80
  protocol = "TCP"
  vpc_id   = aws_vpc.my-vpc.id
}

resource "aws_lb_target_group_attachment" "my-target-grp-association" {
  target_group_arn = aws_lb_target_group.my-target-grp.arn
  target_id        = aws_instance.web.id
  port             = 80
}


resource "aws_lb_listener" "my-listner" {
   load_balancer_arn = aws_lb.my-nlb.arn
   port = "80"
   protocol = "TCP"

    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.my-target-grp.arn
     }

}




