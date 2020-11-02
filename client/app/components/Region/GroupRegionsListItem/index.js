/**
 *
 * Group Regions List Item Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';
import { intlShape } from 'react-intl';

import {
  Grid, Box, Typography, CardContent, CardActions, Button, Collapse,
} from '@material-ui/core';

import { DiverstFormattedMessage } from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Region/messages';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstImg from 'components/Shared/DiverstImg';

const styles = theme => ({
  errorButton: {
    color: theme.palette.error.main,
  },
  subGroupName: {
    fontSize: '1.2rem',
  },
});

export function GroupRegionsListItem(props) {
  const { classes, region, group, intl } = props;

  const [childrenExpanded, setChildrenExpanded] = useState(false);

  return (
    <React.Fragment>
      <CardContent>
        <Typography color='primary' variant='h6'>
          {region.name}
        </Typography>
        {region.short_description && (
          <React.Fragment>
            <Box pt={1} />
            <Typography color='textSecondary'>
              {region.short_description}
            </Typography>
          </React.Fragment>
        )}
      </CardContent>
      <CardActions>
        <Permission show={permission(group, 'update?')}>
          <Button
            size='small'
            color='primary'
            to={ROUTES.admin.manage.groups.regions.edit.path(group.id, region.id)}
            component={WrappedNavLink}
          >
            <DiverstFormattedMessage {...messages.edit} />
          </Button>
        </Permission>
        <Permission show={permission(group, 'destroy?')}>
          <Button
            size='small'
            className={classes.errorButton}
            onClick={() => {
              /* eslint-disable-next-line no-alert, no-restricted-globals */
              if (confirm(intl.formatMessage(messages.delete_confirm)))
                props.deleteRegionBegin({ region_id: region.id, group_id: group.id });
            }}
          >
            <DiverstFormattedMessage {...messages.delete} />
          </Button>
        </Permission>
        <Button
          size='small'
          onClick={() => setChildrenExpanded(!childrenExpanded)}
        >
          {childrenExpanded ? (
            <DiverstFormattedMessage {...messages.children_collapse} />
          ) : (
            <DiverstFormattedMessage {...messages.children_expand} />
          )}
        </Button>
      </CardActions>
      <Collapse in={childrenExpanded}>
        <Box mb={1} ml={1} mr={1}>
          {region.children && region.children.map((subGroup, j) => (
            <Box key={subGroup.id} pt={1} pb={1} pl={3}>
              <Grid container spacing={1} alignItems='center'>
                <Grid item>
                  {subGroup.logo ? (
                    <DiverstImg
                      data={subGroup.logo_data}
                      contentType={subGroup.logo_content_type}
                      maxWidth='40px'
                      maxHeight='40px'
                      minWidth='40px'
                      minHeight='40px'
                    />
                  ) : (
                    <Box
                      maxWidth='40px'
                      maxHeight='40px'
                      minWidth='40px'
                      minHeight='40px'
                    />
                  )}
                </Grid>
                <Grid item xs>
                  <Typography className={classes.subGroupName}>
                    {subGroup.name}
                  </Typography>
                </Grid>
              </Grid>
            </Box>
          ))}
        </Box>
      </Collapse>
    </React.Fragment>
  );
}

GroupRegionsListItem.propTypes = {
  classes: PropTypes.object,
  region: PropTypes.object,
  group: PropTypes.object,
  deleteRegionBegin: PropTypes.func,
  intl: intlShape.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
)(GroupRegionsListItem);
