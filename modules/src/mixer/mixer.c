#include <raylib.h>
#include <raygui.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

#define SCREEN_WIDTH 200
#define SCREEN_HEIGHT 360

#define GridDefine(name, x, y, w, h, offset_x, offset_y, offset_w, offset_h)\
    Rectangle name = {x, y, w, h};\
    Rectangle name##Offset = {offset_x, offset_y, offset_w, offset_h}

#define GridPositionPer(orign, rect) (Rectangle) {(orign.x+orign.width*rect.x/100)+rect##Offset.x, (orign.y+orign.height*rect.y/100)+rect##Offset.y, (orign.width*rect.width/100)-rect##Offset.x-rect##Offset.width, (orign.height*rect.height/100)-rect##Offset.y-rect##Offset.height}

#define GridDefineInPer(name, orign, x, y, w, h, offset_x, offset_y, offset_w, offset_h)\
    GridDefine(name, x, y, w, h, offset_x, offset_y, offset_w, offset_h);\
    name = GridPositionPer(orign, name)


int main(){
	InitWindow(0, 0, "");
	SetWindowState(FLAG_WINDOW_UNDECORATED | FLAG_WINDOW_TOPMOST);

    const int desktopWidth = GetScreenWidth();
    const int desktopHeight = GetScreenHeight();

    GridDefine(DisplayBounds, 0, 0, desktopWidth, desktopHeight, 0, 0, 0, 0);
    GridDefineInPer(WindowBounds, DisplayBounds, 100, 100, 0, 0, -SCREEN_WIDTH-8, -SCREEN_HEIGHT-16, 8, 16);

    SetWindowSize(WindowBounds.width, WindowBounds.height);
    SetWindowPosition(WindowBounds.x, WindowBounds.y);

	FILE *pactl = popen("pactl list short sinks", "r");
    uint64_t lines = 0;
    while(!feof(pactl)){
        if(fgetc(pactl) == '\n') lines++;
    }
    pclose(pactl);

	SetTargetFPS(12);

    uint32_t sinkID[lines];
    int sinkActive = 0;
    char **sinkName = MemAlloc(lines*sizeof(char*));
    for(uint32_t x=0; x<lines; x++){
        sinkName[x] = MemAlloc(1024);
        memset(sinkName[x], 0, 1024);
    }

    memset(sinkID, 0, lines*sizeof(uint32_t));

    pactl = popen("pactl list short sinks", "r");
    for(uint32_t x=0; x<lines; x++){
        char buff[512];
        memset(buff, 0, 512);
        fscanf(pactl, "%ud\t%[^.].", sinkID+x, buff);
        fscanf(pactl, "%[^.].", buff);
        fscanf(pactl, "%[^\t]\t", buff);
        for(int16_t y=0; y<strlen(buff); y++){
            if(buff[y] == '.') buff[y] = ' ';
        }
        strcat(sinkName[x], buff);

        fscanf(pactl, "%[^\t]\t", buff);
        fscanf(pactl, "%[^ ] ", buff);
        fscanf(pactl, "%[^ ] ", buff);
        fscanf(pactl, "%[^\t]\t", buff);
        fscanf(pactl, "%s\n", buff);

        if(!strcmp(buff, "RUNNING")){
            sinkActive = x;
        }
    }
    pclose(pactl);

    int sinkScrool = 0, sinkFocus = sinkActive;

    GridDefine(ScreenRect, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, 0, 0, 0, 0);
    GridDefineInPer(AudioCardList, ScreenRect, 0, 0, 100, 100, 8, 8, 8, 4+52);
    GridDefineInPer(AudioCardVolume, ScreenRect, 0, 100, 100, 0, 8, 4-52, 8, 8);

    GuiSetStyle(LISTVIEW, TEXT_ALIGNMENT, TEXT_ALIGN_LEFT);
    int lastActive = sinkActive;
    char mouseHover = 0;

	while(!WindowShouldClose())	{

		BeginDrawing();{
            ClearBackground((Color){0xd8,0xdb, 0xde, 0xff});
            GuiListViewEx(AudioCardList, (const char**)sinkName, lines,  &sinkScrool, &sinkActive, &sinkFocus);

            DrawRectangleRec(AudioCardVolume, DARKGREEN);
        }EndDrawing();

        if(lastActive != sinkActive){
            lastActive = sinkActive;
            char command[1024] = {0};
            sprintf(command, "pactl set-default-sink %d", sinkID[sinkActive]);
            pclose(popen(command, "r"));
        }

        if(!IsWindowFocused()) break;
	}

    for(uint8_t x=0; x<lines; x++){
        MemFree(sinkName[x]);
    }
    MemFree(sinkName);

	CloseWindow();
}