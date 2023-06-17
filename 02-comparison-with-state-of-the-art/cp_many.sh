find . -name "fuzzware-project-run-??_old" -print | xargs rm -r

# rename when you need

for dir in $(find . -type d -name "fuzzware-project-run-02"); do
  parent_dir=$(dirname "$dir")
  mv "$dir" "$parent_dir/fuzzware-project-run-05"
done

# mv all the fuzzware-project-run-?? to /data/

nowPath=~/fuzzware/fuzzware-experiments/02-comparison-with-state-of-the-art
# afterPath=/data/bb_based_data_1_day
afterPath=$1

for dir in $(find "$nowPath" -type d -name "fuzzware-project-run-??"); do
  relative_path=${dir#$nowPath/}
  target_dir="$afterPath/$relative_path"
  if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
  fi
  mv $dir/* $target_dir/
done

