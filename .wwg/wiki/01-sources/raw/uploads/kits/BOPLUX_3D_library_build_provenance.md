# BOPLUX Licensed 3D Library — Phase B build provenance (2026-09-09)

Source: `src_20260909_boplux_licensed_3d_library` (Kenney CC0 + Poly Haven CC0; see library doc + manifest alongside).

## What was built

- `ServerStorage.AssetLibrary` in the Studio datamodel: 204 models built at ×7.14 scale (1 Kenney unit = 2 m = 7.14 studs) from the library's OBJ files via the scripted pipeline in `ServerStorage.AssetLibraryBuilder` (localhost OBJ relay → HttpService → Luau OBJ parser → EditableMesh → CreateMeshPartAsync).
- Categories: RetroUrban (111), FurnitureKit (55), Clutter (26), Lighting (12).

## Uploaded texture atlas asset IDs (retro-urban-kit, CC0, no attribution required)

Extracted from the official Kenney retro-urban-kit ZIP (downloaded 2026-09-09 from `https://kenney.nl/media/pages/assets/retro-urban-kit/8314d4db22-1738147509/kenney_retro-urban-kit.zip`, kit version 2.0, `Textures/` folder) and uploaded to the Asset Server:

| Material | Asset ID |
|---|---|
| asphalt | rbxassetid://75254886050494 |
| bars | rbxassetid://71866471100180 |
| concrete | rbxassetid://133775529284486 |
| dirt | rbxassetid://137342846652184 |
| doors | rbxassetid://71160448746355 |
| grass | rbxassetid://103044193029788 |
| metal | rbxassetid://127974754338051 |
| metal_wall | rbxassetid://110920002770170 |
| planks | rbxassetid://133841176878548 |
| rock | rbxassetid://91026691889956 |
| roof | rbxassetid://130615256391261 |
| roof_plates | rbxassetid://132241426950960 |
| signs | rbxassetid://134065903143909 |
| tiles | rbxassetid://120574559327427 |
| treeA | rbxassetid://135722202399691 |
| treeB | rbxassetid://111732789641458 |
| truck | rbxassetid://103761544452368 |
| truck_alien | rbxassetid://114238781932835 |
| wall | rbxassetid://97368315421620 |
| wall_garage | rbxassetid://94704756122480 |
| wall_lines | rbxassetid://125195473061354 |
| windows | rbxassetid://115697280321883 |

## Furniture-kit palette

Exact `baseColorFactor` values extracted from the furniture-kit GLBs (15 materials: wood, woodDark, metal, metalDark, metalLight, metalMedium, carpet, carpetWhite, carpetBlue, carpetDarker, lamp, glass, fur, plant, _defaultMat) — baked into `AssetLibraryBuilder.MTL_COLORS`.

## License note

All assets CC0 1.0 (Kenney). No attribution required. No restricted-source content used (see `BOPLUX_3D_library_flagged_items.md`).
