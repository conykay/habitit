import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/habits/bloc/selected_frequency_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';

import '../../../domain/habits/entities/habit_entity.dart';
import '../widget/habits_list_widget.dart';
import '../widget/new_habit_modal.dart';

class HabitsPage extends StatelessWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<HabitStateCubit>().getHabits();
      },
      child: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width >= 600 ? 400 : null,
          child: Stack(
            children: [
              HabitsView(),
              CreateHabitFloatingButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class HabitsView extends StatelessWidget {
  const HabitsView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: BlocBuilder<HabitStateCubit, HabitState>(
        builder: (context, state) {
          switch (state) {
            case HabitLoading():
              final bool hasData = context.read<HabitStateCubit>().hasData;
              if (hasData && state.oldHabits != null) {
                return _buildHabitsView(
                    allHabits: state.oldHabits!, loading: true);
              }
              return const Center(child: CircularProgressIndicator());
            case HabitLoaded():
              return _buildHabitsView(allHabits: state.habits);
            case HabitError():
              return Center(
                child: Text(state.message),
              );
            default:
              return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Column _buildHabitsView(
      {required List<HabitEntity> allHabits, bool loading = false}) {
    return Column(
      children: [
        AnimatedContainer(
            duration: Duration(seconds: 1),
            child: loading ? LinearProgressIndicator() : SizedBox()),
        allHabits.isNotEmpty
            ? Expanded(child: HabitsListView(habits: allHabits))
            : Expanded(
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: const Center(
                    child: Text(
                      'Add a Habit to Get Going',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ),
      ],
    );
  }
}

class CreateHabitFloatingButton extends StatelessWidget {
  const CreateHabitFloatingButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
          padding: const EdgeInsets.only(bottom: 20.0, right: 20),
          child: FloatingActionButton(
            onPressed: () {
              _createNewHabit(context);
            },
            child: FaIcon(
              FontAwesomeIcons.plus,
              color: Theme.of(context).primaryColor,
            ),
          )),
    );
  }

  void _createNewHabit(BuildContext context) async {
    final selectedCubit = context.read<SelectedFrequencyCubit>();
    final habitState = context.read<HabitStateCubit>();
    final rewardState = context.read<UserRewardsCubit>();

    late bool result;
    if (kIsWeb) {
      result = await showDialog(
          context: context,
          builder: (context) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: habitState,
                ),
                BlocProvider.value(
                  value: selectedCubit,
                ),
                BlocProvider.value(
                  value: rewardState,
                ),
              ],
              child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: NewHabitCustomModal()),
            );
          });
    } else {
      result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return MultiBlocProvider(
            providers: [
              BlocProvider.value(
                value: habitState,
              ),
              BlocProvider.value(
                value: selectedCubit,
              ),
              BlocProvider.value(
                value: rewardState,
              ),
            ],
            child: NewHabitCustomModal(),
          );
        },
      );
    }

    if (result == true) {
      if (context.mounted) {
        context.read<HabitStateCubit>().getHabits();
      }
    }
  }
}
