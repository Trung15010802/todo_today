part of 'bottom_nav_bloc.dart';

abstract class BottomNavState extends Equatable {
  final int index;
  const BottomNavState(
    this.index,
  );

  @override
  List<Object> get props => [index];
}

class BottomNavInitial extends BottomNavState {
  const BottomNavInitial() : super(0);
}

class BottomNavChangeState extends BottomNavState {
  const BottomNavChangeState(int index) : super(index);
}
