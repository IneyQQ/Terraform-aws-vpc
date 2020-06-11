output id {
  value = aws_vpc.main.id
}
output private_subnet_ids {
  value = aws_subnet.private.*.id
}
output public_subnet_ids {
  value = aws_subnet.public.*.id
}
output nointernet_subnet_ids {
  value = aws_subnet.nointernet.*.id
}
