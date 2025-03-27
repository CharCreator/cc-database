SELECT file_name, cover
FROM assets
WHERE asset_type = $1
  AND character_sex = $2 ;
