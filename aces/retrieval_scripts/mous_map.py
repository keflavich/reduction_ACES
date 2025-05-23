import os
from astroquery.alma import Alma
import json
from .. import conf

datapath = f'{conf.basepath}/data/'


def get_mous_to_sb_mapping(project_code, refresh=False, mousmapfile=f'{datapath}/mous_mapping.json', verbose=False):
    if refresh or not os.path.exists(mousmapfile):
        if verbose:
            print("Downloading MOUS map from ALMA archive")
        tbl = Alma.query(payload={'project_code': project_code},
                         public=None)['member_ous_uid', 'schedblock_name', 'qa2_passed']
        # obsolete mapping = {row['member_ous_uid']: row['schedblock_name'] for row in tbl if row['qa2_passed'] == 'T'}
        mapping = {row['member_ous_uid']: row['schedblock_name'] for row in tbl}
        with open(mousmapfile, 'w') as fh:
            json.dump(mapping, fh)
    else:
        if verbose:
            print(f"Recovering MOUS map from {mousmapfile}")
        with open(mousmapfile, 'r') as fh:
            mapping = json.load(fh)
    return mapping
