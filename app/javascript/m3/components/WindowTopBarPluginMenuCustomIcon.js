import React from 'react';
import SvgIcon from '@material-ui/core/SvgIcon';

const CustomIcon = (props) => (
  <SvgIcon {...props}>
    <svg xmlns="http://www.w3.org/2000/svg" height="24" viewBox="0 0 24 24" width="24"><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/><path d="M0 0h24v24H0z" fill="none"/></svg>
  </SvgIcon>
);

export const WindowTopBarPluginMenuCustomIcon = (plugin) => (
  <div>
    <plugin.TargetComponent menuIcon={<CustomIcon/>} {...plugin.targetProps} {...plugin} />
  </div>
);
