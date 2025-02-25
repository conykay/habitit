// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habitit/domain/habits/entities/habit_enity.dart';
import 'package:habitit/domain/habits/repository/habit_repository.dart';
import 'package:habitit/domain/habits/usecases/get_all_habits_usecase.dart';
import 'package:habitit/domain/rewards/repository/rewards_repository.dart';
import 'package:habitit/presentation/habits/bloc/habit_state.dart';
import 'package:habitit/presentation/habits/bloc/habit_state_cubit.dart';
import 'package:habitit/presentation/habits/bloc/selected_frequency_cubit.dart';
import 'package:habitit/presentation/profile/bloc/user_rewards_cubit.dart';

import '../widget/habits_list_widget.dart';
import '../widget/new_habit_modal.dart';

// ignore: must_be_immutable
class HabitsPage extends StatelessWidget {
  HabitsPage({super.key});

  List<HabitEnity>? allHabits;

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<HabitStateCubit>()
        ..getHabits(
            usecase: GetAllHabitsUsecase(
                repository: context.read<HabitRepository>())),
      child: Center(
        child: SizedBox(
          width: MediaQuery.sizeOf(context).width >= 600 ? 400 : null,
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: BlocBuilder<HabitStateCubit, HabitState>(
                  builder: (context, state) {
                    var loading = state is HabitLoading;

                    if (state is HabitError) {
                      return Center(
                        child: Text(state.message),
                      );
                    }

                    if (state is HabitLoaded) {
                      allHabits = state.habits;
                    }
                    if (allHabits != null) {
                      if (allHabits!.isEmpty) {
                        return Center(
                          child: Text(
                            'Create a Habit to Get Going',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        );
                      }
                      return Column(
                        children: [
                          loading
                              ? Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
                                  child: LinearProgressIndicator())
                              : SizedBox(),
                          Expanded(child: HabitsListView(habits: allHabits!)),
                        ],
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20.0, right: 20),
                  child: Builder(builder: (context) {
                    return FloatingActionButton(
                      onPressed: () async {
                        await _createNewHabit(context);
                      },
                      child: FaIcon(FontAwesomeIcons.plus),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createNewHabit(BuildContext context) async {
    final habitRepo = context.read<HabitRepository>();
    final rewardRepo = context.read<RewardsRepository>();
    final selectedCubit = context.read<SelectedFrequencyCubit>();
    final habitstate = context.read<HabitStateCubit>();
    final rewardState = context.read<UserRewardsCubit>();

    late bool result;
    if (kIsWeb) {
      result = await showDialog(
          context: context,
          builder: (context) {
            return MultiRepositoryProvider(
              providers: [
                RepositoryProvider.value(
                  value: habitRepo,
                ),
                RepositoryProvider.value(
                  value: rewardRepo,
                ),
              ],
              child: MultiBlocProvider(
                providers: [
                  BlocProvider.value(
                    value: habitstate,
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
              ),
            );
          });
    } else {
      result = await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return MultiRepositoryProvider(
            providers: [
              RepositoryProvider.value(
                value: habitRepo,
              ),
              RepositoryProvider.value(
                value: rewardRepo,
              ),
            ],
            child: MultiBlocProvider(
              providers: [
                BlocProvider.value(
                  value: habitstate,
                ),
                BlocProvider.value(
                  value: selectedCubit,
                ),
                BlocProvider.value(
                  value: rewardState,
                ),
              ],
              child: NewHabitCustomModal(),
            ),
          );
        },
      );
    }

    if (result == true) {
      if (context.mounted) {
        context.read<HabitStateCubit>().getHabits(
            usecase: GetAllHabitsUsecase(
                repository: context.read<HabitRepository>()));
      }
    }
  }
}
