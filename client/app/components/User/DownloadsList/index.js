/**
 *
 * Downloads List Component
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Paper, Card, CardContent, Grid, Link, Typography, Button, CardActionArea, CircularProgress,
} from '@material-ui/core';

import DownloadIcon from '@material-ui/icons/GetApp';
import InfoIcon from '@material-ui/icons/InfoOutlined';

import messages from 'containers/User/messages';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';

//import download from 'downloadjs';

const styles = theme => ({
  fileName: {
    fontStyle: 'italic',
    fontSize: '1.1rem',
  },
  infoIcon: {
    marginRight: 4,
  },
  downloadProgress: {
    verticalAlign: 'middle',
  },
});

export function DownloadsList(props, context) {
  const { classes } = props;

  const [fileName, setFileName] = useState(null);

  useEffect(() => {
    if (fileName && props.downloadData.data) {
      //download(props.downloadData.data, fileName, props.downloadData.contentType);
      setFileName(null);
    }
  }, [props.downloadData.data]);

  return (
    <React.Fragment>
      <Grid container justify='flex-end'>
        <Grid item>
          <Grid container justify='center'>
            <Grid item>
              <InfoIcon fontSize='small' color='secondary' className={classes.infoIcon} />
            </Grid>
            <Grid item>
              <Typography color='textSecondary'>
                <DiverstFormattedMessage {...messages.downloads.expireInfo} />
              </Typography>
            </Grid>
          </Grid>
        </Grid>
      </Grid>
      <Box pt={2} />
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.downloads && props.downloads.map((item, i) => {
            return (
              <Grid item key={item.id} sm={12}>
                <Card>
                  <CardContent>
                    <Grid container spacing={3} alignItems='center'>
                      <Grid item>
                        <Typography className={classes.fileName}>
                          {item.file_name}
                        </Typography>
                      </Grid>
                      <Grid item>
                        <Typography color='textSecondary'>
                          {formatDateTimeString(item.created_at, DateTime.DATETIME_MED)}
                        </Typography>
                      </Grid>
                      <Grid item sm>
                        <Grid container spacing={1} justify='flex-end' alignItems='center'>
                          {props.isDownloadingData && fileName && (
                            <Grid item>
                              <CircularProgress size={30} color='primary' className={classes.downloadProgress} />
                            </Grid>
                          )}
                          <Grid item>
                            <Button
                              color='primary'
                              variant='contained'
                              size='large'
                              startIcon={<DownloadIcon />}
                              disabled={props.isDownloadingData}
                              onClick={() => {
                                setFileName(item.file_name);
                                props.getUserDownloadDataBegin(item.download_file_path);
                              }}
                            >
                              <DiverstFormattedMessage {...messages.downloads.downloadButton} />
                            </Button>
                          </Grid>
                        </Grid>
                      </Grid>
                    </Grid>
                  </CardContent>
                </Card>
              </Grid>
            );
          })}
          {props.downloads && props.downloads.length <= 0 && (
            <React.Fragment>
              <Grid item sm={12}>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <DiverstFormattedMessage {...messages.downloads.empty} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
      </DiverstLoader>
      {props.downloads && props.downloads.length > 0 && (
        <DiverstPagination
          isLoading={props.isLoading}
          count={props.downloadsTotal}
          handlePagination={props.handlePagination}
        />
      )}
    </React.Fragment>
  );
}

DownloadsList.propTypes = {
  classes: PropTypes.object,
  getUserDownloadDataBegin: PropTypes.func.isRequired,
  downloads: PropTypes.array,
  downloadsTotal: PropTypes.number,
  downloadData: PropTypes.object,
  isLoading: PropTypes.bool,
  isDownloadingData: PropTypes.bool,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(DownloadsList);
