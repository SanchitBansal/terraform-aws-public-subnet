output "public_subnet_id" {
  value = "${aws_subnet.public.*.id}"
}

output "nat_gateway_ids" {
  value = "${aws_nat_gateway.nat.*.id}"
}
