import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:notes_keeper/bloc/notes/notes_bloc.dart';
import 'package:notes_keeper/bloc/notes/notes_event.dart';
import 'package:notes_keeper/bloc/notes/notes_state.dart';
import 'package:notes_keeper/models/note.dart';
import 'package:notes_keeper/screens/add_update_note_screen.dart';
import 'package:notes_keeper/screens/search_note_screen.dart';
import 'package:notes_keeper/screens/watch_note_screen.dart';
import 'package:notes_keeper/utils/assets_constants.dart';
import 'package:notes_keeper/utils/color_constants.dart';
import 'package:notes_keeper/widgets/action_icon_widget.dart';
import 'package:notes_keeper/widgets/delete_note_alert_dialog_widget.dart';
import 'package:notes_keeper/widgets/delete_notes_alert_dialog_widget.dart';
import 'package:notes_keeper/widgets/dismissible_background.dart';
import 'package:notes_keeper/widgets/empty_notes_ui_widget.dart';
import 'package:notes_keeper/widgets/listing_icon_widget.dart';
import 'package:notes_keeper/widgets/notes_grid_item_widget.dart';
import 'package:notes_keeper/widgets/notes_list_item_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  late Size _size = const Size(0, 0);
  bool _showGrid = true;
  List<Note> _noteList = [];
  bool _wannaDeleteListItem = false;

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildAddNoteFAB(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Notes Keeper'),
      actions: [
        buildActionIcon(
          iconPath: AssetsConsts.icDustbin,
          onTap: () async {
            if (_noteList.isNotEmpty) {
              bool agree = await showDeleteAllNotesDialog(context);
              if (agree) {
                context.read<NotesBloc>().add(DeleteAllNotesEvent());
              }
            }
          },
          rightMargin: 8.0,
        ),
        buildActionIcon(
          iconPath: AssetsConsts.icSearch,
          onTap: () {
            if (_noteList.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SearchNoteScreen(),
                ),
              );
            }
          },
          rightMargin: 10.0,
        ),
      ],
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.only(
        left: _size.height * 0.015,
        right: _size.height * 0.015,
        bottom: _size.height * 0.015,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: _size.height * 0.015,
              right: _size.height * 0.015,
              bottom: _size.height * 0.015,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: Container(
                      padding: EdgeInsets.only(
                        bottom: _size.height * 0.01,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: AppColors.white,
                            width: 2.0,
                          ),
                        ),
                      ),
                      child: Text(
                        'All Notes',
                        style:
                            Theme.of(context).textTheme.headlineSmall!.copyWith(
                                  color: AppColors.lightGray,
                                ),
                      ),
                    ),
                  ),
                ),
                buildListingIcon(
                  AssetsConsts.icGrid,
                  () {
                    if (_showGrid) {
                      return;
                    } else {
                      context.read<NotesBloc>().add(ShowNotesInGridEvent());
                    }
                  },
                ),
                buildListingIcon(
                  AssetsConsts.icList,
                  () {
                    if (!_showGrid) {
                      return;
                    } else {
                      context.read<NotesBloc>().add(ShowNotesInListEvent());
                    }
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: BlocBuilder<NotesBloc, NotesState>(
              builder: (context, state) {
                if (state is NotesLoadingState || state is NotesInitialState) {
                  return _buildLoading();
                } else if (state is NotesLoadedState) {
                  _noteList = state.notes;
                  return _buildListOrEmpty();
                } else if (state is AllNotesDeletedState) {
                  _noteList = [];
                  return _buildListOrEmpty();
                } else if (state is ShowNotesInViewState) {
                  _showGrid = state.inGrid;
                  return _buildListOrEmpty();
                } else if (state is DeleteNoteState) {
                  _noteList = state.notes;
                  return _buildListOrEmpty();
                } else if (state is CreateNoteState) {
                  _noteList = state.notes;
                  return _buildListOrEmpty();
                } else if (state is UpdateNoteState) {
                  _noteList = state.notes;
                  return _buildListOrEmpty();
                } else if (state is NotesErrorState) {
                  return Center(
                    child: Text(state.message),
                  );
                } else {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildAddNoteFAB() {
    return TweenAnimationBuilder<Offset>(
      duration: const Duration(seconds: 2),
      tween: Tween<Offset>(
        begin: const Offset(0, -800),
        end: const Offset(0, 0),
      ),
      curve: Curves.bounceOut,
      builder: (context, Offset offset, child) {
        return Transform.translate(
          offset: offset,
          child: child,
        );
      },
      child: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddUpdateNoteScreen(),
            ),
          );
        },
        backgroundColor: AppColors.white,
        child: Icon(
          Icons.add,
          color: AppColors.codGray,
          size: _size.width * 0.08,
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return const Center(
        child: CircularProgressIndicator(
      color: AppColors.white,
    ));
  }

  Widget _buildListOrEmpty() {
    if (_noteList.isEmpty) {
      return buildEmptyNotesUi(_size, path: AssetsConsts.svgEmptyNotes);
    } else {
      return _showGrid ? _buildNotesGridView() : _buildNotesListView();
    }
  }

  Widget _buildNotesGridView() {
    return AnimationLimiter(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: _size.height * 0.01,
          crossAxisSpacing: _size.height * 0.01,
        ),
        itemCount: _noteList.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 2,
            duration: const Duration(milliseconds: 500),
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: NotesGridItem(
                  note: _noteList[index],
                  onGridItemTap: onNoteItemTap(index),
                  onGridItemLongPress: onNoteItemLongPress(index),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotesListView() {
    return AnimationLimiter(
      child: ListView.builder(
        itemCount: _noteList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: ObjectKey(_noteList[index]),
            direction: DismissDirection.startToEnd,
            confirmDismiss: deleteNoteConfirmDismiss(index),
            background: buildDismissibleBackground(
              size: _size,
              color: Colors.red,
              icon: Icons.delete,
              title: 'Delete',
            ),
            child: AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50,
                child: FadeInAnimation(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: _size.width * 0.01),
                    child: SizedBox(
                      width: double.infinity,
                      child: NotesListItem(
                        size: _size,
                        note: _noteList[index],
                        onTap: onNoteItemTap(index),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  VoidCallback onNoteItemTap(int index) {
    return () async {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => WatchNoteScreen(
            note: _noteList[index],
          ),
        ),
      );
    };
  }

  VoidCallback onNoteItemLongPress(int index) {
    return () async {
      bool wannaDeleteGridItem = await showDeleteNoteDialog(context);

      if (wannaDeleteGridItem) {
        context.read<NotesBloc>().add(DeleteNoteEvent(_noteList[index].id!));
        wannaDeleteGridItem = false;
      }
    };
  }

  ConfirmDismissCallback deleteNoteConfirmDismiss(int index) {
    return (direction) async {
      _wannaDeleteListItem = await showDeleteNoteDialog(context);

      if (_wannaDeleteListItem) {
        context.read<NotesBloc>().add(DeleteNoteEvent(_noteList[index].id!));
        _wannaDeleteListItem = false;

        return true;
      }

      return false;
    };
  }
}
