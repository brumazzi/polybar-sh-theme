#include <vector>
#include <iostream>
#include <memory>
#include "configs/widgets-config.cpp"

#define DEFAULT_RADIO_POSITION(win,i, x,y,w,h) int x = 0, y = 26*i+40, w = win.w(), h=26

int show_sound_card(int argc, char** argv);
int show_i3_desktop(int argc, char** argv);

int main(int argc, char** argv) {
    if (argc == 1) return 0;

    load_fonts();
    if(!strcmp(argv[1], "sound-card")){
        return show_sound_card(argc, argv);
    }else if(!strcmp(argv[1], "i3-desktop")){
        return show_i3_desktop(argc, argv);
    }

    printf("Usage polybar-widget <option> [args] ...\n");
    printf("\tsound-card                         Open Output audio card selector.\n");
    printf("\ti3-desktop [arg1 arg2 ...]         Open range of screens to select.\n");
    printf("\n");


    return 0;
}

int show_i3_desktop(int argc, char** argv){
    WindowAutoClose win(200, 10, "i3 Desktop");
    win.set_override();

    BoxStyled box(12, 8, win.w(), 22, "i3 Desktop");

    std::vector<std::unique_ptr<RadioButtonStyled>> items;
    char items_name[argc-2][120];

    int current_desktop = 0;
    FILE* desktop_F = popen("i3-msg -t get_workspaces | jq -r '.[] | select(.focused==true).name'", "r");
    fscanf(desktop_F, "%d", &current_desktop);
    fclose(desktop_F);

    for(int i=0; i<argc-2; i++){
        DEFAULT_RADIO_POSITION(win, i, x,y,w,h);

        sprintf(items_name[i], "Desktop %.02d", i+1);
        items.emplace_back(std::make_unique<RadioButtonStyled>(x, y, w, h, items_name[i], "", i+1));
        items[i]->callback([](Fl_Widget* widget, void* data){
            auto radio = (RadioButtonStyled*)widget;
            int fork_pid = fork();
            if(!fork_pid){
                char param[8];
                sprintf(param, "%d", radio->flag_value);
                puts(param);
                const char* args[] = {"i3-msg", "workspace", param, NULL};
                execvp(args[0], (char**)args);
            }

            int status;
            waitpid(fork_pid, &status, 0);
        });
        if(i+1 == current_desktop) items[i]->value(1);
    }

    win.size(win.w(), 40+26*(argc-2));
    win.show();

    return Fl::run();
}

int show_sound_card(int argc, char** argv){
    FILE* f = popen("pactl list short sinks | wc -l", "r");
    int cards_count = 0;
    fscanf(f, "%d", &cards_count);
    pclose(f);

    WindowAutoClose win(200, 300, "Audio Cards");
    // win.set_modal();
    win.set_override();

    BoxStyled box(12, 8, win.w(), 22, "Audio Cards");

    std::vector<std::unique_ptr<RadioButtonStyled>> items;
    items.reserve(cards_count);
    FILE* cards_F = popen("pactl list short sinks", "r");
    int card_id = 0;
    char card_name[cards_count][120];
    char card_icon[cards_count][16];

    for (int i = 0; i < cards_count; i++) {
        DEFAULT_RADIO_POSITION(win, i, x,y,w,h);

        char buff[64] = {0};
        fscanf(cards_F, "%d %s", &card_id, card_name[i]);
        fscanf(cards_F, "%s", buff);
        fscanf(cards_F, "%s", buff);
        fscanf(cards_F, "%s", buff);
        fscanf(cards_F, "%s", buff);
        fscanf(cards_F, "%s", buff);

        // get card alias
        char command[160];
        char name_buff[60];
        sprintf(command, "cat $HOME/.alsacard-mnemonic | grep '%s'",
                card_name[i]);
        FILE* alias_F = popen((const char*)command, "r");
        if (alias_F) {
            fscanf(alias_F, "%s %s %[^\n]", name_buff, command, card_icon[i]);
            if (strlen(name_buff) > 2) {
                strcpy(card_name[i], name_buff);
            }
            pclose(alias_F);
        }

        items.emplace_back(std::make_unique<RadioButtonStyled>(x, y, w, h, card_name[i], card_icon[i], card_id));
        items[i]->callback([](Fl_Widget* widget, void* data) {
            pid_t fork_pid = fork();
            auto radio = (RadioButtonStyled*)widget;
            if (!fork_pid) {
                char buff[180];
                sprintf(buff, "%d", radio->flag_value);
                const char* args[] = {"pactl", "set-default-sink", buff, NULL};
                execvp(args[0], (char**)args);
            }

            int status;
            waitpid(fork_pid, &status, 0);

            if (status == 0) {
                struct passwd* pwd = getpwuid(getuid());
                char selected[80];
                sprintf(selected, "%s/.alsacard-target", pwd->pw_dir);
                FILE* selected_F = fopen(selected, "w");
                fprintf(selected_F, "%s: %%{F#4d8ddb}%s%%{F-}", radio->icon,
                        radio->label());
                fclose(selected_F);
            }
        });

        if (!strcmp(buff, "RUNNING")) items[i]->value(1);
    }
    pclose(cards_F);
    win.size(win.w(), cards_count * 26 + 40);

    win.show();

    return Fl::run();
}