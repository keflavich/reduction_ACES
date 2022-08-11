#!/bin/bash
#SBATCH --mail-type=NONE          # Mail events (NONE, BEGIN, END, FAIL, ALL)
#SBATCH --mail-user=adamginsburg@ufl.edu     # Where to send mail
#SBATCH --time=96:00:00               # Time limit hrs:min:sec
#SBATCH --ntasks=16
#SBATCH --mem=64gb
#SBATCH --nodes=1 # exactly 1 node
#SBATCH --time=96:00:00               # Time limit hrs:min:sec
#SBATCH --qos=astronomy-dept-b
#SBATCH --account=astronomy-dept
#SBATCH --output=/blue/adamginsburg/adamginsburg/ACES/logs/ACES_retrieval_%j.log
#SBATCH --job-name=ACES_retrieval
#SBATCH --export=ALL


date

. ~/.gh_token
echo $GITHUB_TOKEN

cd /orange/adamginsburg/ACES/rawdata

echo "test import"
/orange/adamginsburg/miniconda3/envs/python39/bin/python -c "import zipfile"
echo "Retrieve data"
aces_retrieve_data keflavich True True
echo "Retrieve weblogs"
aces_retrieve_weblogs keflavich


export WEBLOG_DIR=/orange/adamginsburg/web/secure/ACES/weblogs/
export WEBLOG_DIR='/orange/adamginsburg/ACES/rawdata/2021.1.00172.L/weblogs'

echo "Make links"
/orange/adamginsburg/miniconda3/envs/python39/bin/aces_make_humanreadable_links
echo "Update github"
/orange/adamginsburg/miniconda3/envs/python39/bin/aces_ghapi_update


echo "Make 7m mosaic"
/orange/adamginsburg/miniconda3/envs/python39/bin/aces_mosaic_7m
echo "Make 12m mosaic"
/orange/adamginsburg/miniconda3/envs/python39/bin/aces_mosaic_12m
echo "Make TP mosaic"
/orange/adamginsburg/miniconda3/envs/python39/bin/aces_mosaic_TP

# technically shouldn't need to be re-run, but as I add new mosaics, it will
ln -s /orange/adamginsburg/ACES/mosaics/*png /orange/adamginsburg/web/secure/ACES/mosaics/
