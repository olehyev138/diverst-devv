import React, { memo, useState, useEffect, useRef } from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import { injectIntl, intlShape } from 'react-intl';

import { Button, FormControl, FormHelperText, FormLabel, Grid, Typography, Box, CircularProgress, IconButton, Divider } from '@material-ui/core';
import UploadIcon from '@material-ui/icons/CloudUpload';
import DeleteIcon from '@material-ui/icons/DeleteForever';

import classNames from 'classnames';

import { DirectUploadProvider } from 'react-activestorage-provider';

import config from 'app.config';
import AuthService from 'utils/authService';

import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'components/Shared/DiverstFileInput/messages';

const styles = theme => ({
  fileInput: {
    display: 'none',
  },
  uploadSection: {
    marginTop: 12,
  },
  fileInfo: {
    fontSize: 16,
    verticalAlign: 'middle',
  },
  fileName: {
    color: theme.palette.grey.A700,
  },
  uploadButton: {

  },
  fileInfoBox: {
    minWidth: 64,
    display: 'inline-block',
    borderRadius: 4,
    borderWidth: 1,
    borderColor: '#BBBBBB',
    borderStyle: 'solid',
    borderBottom: 'none !important',
    paddingTop: 0,
    paddingBottom: 0,
    paddingLeft: 12,
    paddingRight: 12,
    boxShadow: '0px 3px 1px -2px rgba(0,0,0,0.2), 0px 2px 2px 0px rgba(0,0,0,0.14), 0px 1px 5px 0px rgba(0,0,0,0.12)',
    '& *': {
      lineHeight: 1.75,
    },
    textAlign: 'center',
  },
  fileInfoBoxWithFile: {
    paddingRight: 6,
  },
  fileInfoDivider: {
    display: 'inline-block'
  },
  fileInfoBoxTypography: {
    paddingTop: 4,
    paddingBottom: 3,
  },
  uploadProgress: {
    marginLeft: 8,
    verticalAlign: 'middle',
  },
  uploadProgressPercent: {
    marginLeft: 6,
    color: theme.palette.primary.main,
  },
  deleteButton: {
    marginLeft: 6,
    color: theme.palette.error.main,
  },
});

const apiURL = new URL(config.apiUrl);

export function DiverstFileInput(props) {
  const { classes, form, handleUploadBegin, handleUploadSuccess, handleUploadError, intl, ...rest } = props;

  const [uploadedFile, setUploadedFile] = useState(null);
  const inputRef = useRef();

  // Note: the fileName prop is only used for edit forms to show the existing file name
  useEffect(() => {
    if (props.fileName)
      setUploadedFile(props.fileName);
  }, [props.fileName]);

  /* eslint-disable-next-line prefer-destructuring */
  const apiKey = config.apiKey;
  const userToken = AuthService.getJwt();

  // Form Control props
  const {
    disabled,
    error,
    fullWidth,
    hiddenLabel,
    margin,
    required,
    variant,
    value,
    multiple,
    inputProps,
  } = rest;

  return (
    <React.Fragment>
      <DirectUploadProvider
        multiple={multiple}
        origin={{
          host: apiURL.hostname,
          port: apiURL.port,
          protocol: apiURL.protocol.slice(0, -1),
        }}
        headers={{
          'Diverst-APIKey': apiKey,
          'Diverst-UserToken': userToken,
        }}
        onBeforeStorageRequest={({ id, file, xhr }) => {
          // Necessary as the `headers` prop doesn't seem to pass the headers for the storage request
          // See: https://github.com/cbothner/react-activestorage-provider/issues/50
          xhr.setRequestHeader('Diverst-APIKey', apiKey);
          xhr.setRequestHeader('Diverst-UserToken', userToken);
        }}
        onSuccess={(object) => {
          if (!object || object.length <= 0)
            return;

          if (multiple)
            form.setFieldValue(props.id, object);
          else
            form.setFieldValue(props.id, object.pop());

          if (handleUploadSuccess)
            handleUploadSuccess(object);
        }}
        onError={handleUploadError}
        render={({ handleUpload, uploads, ready }) => (
          <React.Fragment>
            <FormControl
              error={error}
              fullWidth={fullWidth}
              hiddenLabel={hiddenLabel}
              margin={margin}
              required={required}
              variant={variant}
            >
              <FormLabel
                htmlFor={props.id}
                error={error}
                required={required}
              >
                {props.label}
              </FormLabel>
              <input
                accept='image/*'
                id={props.id}
                type='file'
                className={classes.fileInput}
                ref={inputRef}
                disabled={disabled || !ready}
                // eslint-disable-next-line no-return-assign
                onClick={e => e.target.value = ''}
                onChange={(e) => {
                  if (handleUploadBegin)
                    handleUploadBegin(e);

                  handleUpload(e.currentTarget.files);
                }}
                {...inputProps}
              />
              <Grid container spacing={1} alignItems='center' className={classes.uploadSection}>
                <Grid item>
                  <Button
                    className={classes.uploadButton}
                    color='primary'
                    component='span'
                    variant='contained'
                    onClick={() => inputRef.current.click()}
                    disabled={disabled || !ready}
                    startIcon={<UploadIcon />}
                  >
                    {value ? <DiverstFormattedMessage {...messages.replace} /> : <DiverstFormattedMessage {...messages.choose} />}
                  </Button>
                </Grid>
                <Grid item>
                  {!disabled && (
                    <Box className={classNames(classes.fileInfoBox, value && classes.fileInfoBoxWithFile)}>
                      {uploads.map((upload) => {
                        switch (upload.state) {
                          case 'waiting':
                            return (
                              <Typography variant='h6' className={classes.fileInfo} color='textSecondary' key={upload.id}>
                                <span><DiverstFormattedMessage {...messages.waiting} /></span>
                                <span className={classes.fileName}>{upload.file.name}</span>
                                <CircularProgress
                                  className={classes.uploadProgress}
                                  size={20}
                                />
                              </Typography>
                            );
                          case 'uploading':
                            return (
                              <Typography variant='h6' className={classes.fileInfo} color='textSecondary' key={upload.id}>
                                <span>
                                  <DiverstFormattedMessage {...messages.uploading} />
                                </span>
                                <span className={classes.fileName}>{upload.file.name}</span>
                                <CircularProgress
                                  variant='determinate'
                                  className={classes.uploadProgress}
                                  size={20}
                                  value={Math.round(upload.progress)}
                                />
                                <span className={classes.uploadProgressPercent}>
                                  {Math.round(upload.progress)}
                                  <span>%</span>
                                </span>
                              </Typography>
                            );
                          case 'error':
                            return (
                              <Typography variant='h6' className={classes.fileInfo} color='error' key={upload.id}>
                                <span><DiverstFormattedMessage {...messages.error} /></span>
                                {upload.file.name}
                              </Typography>
                            );
                          case 'finished':
                            setUploadedFile(upload.file.name);
                            return (
                              <Typography variant='h6' className={classes.fileInfo} color='textSecondary' key={upload.id}>
                                <span><DiverstFormattedMessage {...messages.finished} /></span>
                                <span className={classes.fileName}>{upload.file.name}</span>
                                <CircularProgress
                                  variant='determinate'
                                  className={classes.uploadProgress}
                                  size={20}
                                  value={100}
                                />
                              </Typography>
                            );
                          default:
                            return (<React.Fragment />);
                        }
                      })}

                      {value && ready && (
                        <Grid container alignItems='center' wrap='nowrap'>
                          <Grid item>
                            <Box pr={1}>
                              <Typography variant='h6' color='primary' className={classNames(classes.fileInfo, classes.fileInfoBoxTypography)}>
                                {uploadedFile}
                              </Typography>
                            </Box>
                          </Grid>
                          {!required && (
                            <React.Fragment>
                              <Divider orientation='vertical' flexItem />
                              <Grid item>
                                <Typography display='inline' variant='h6' className={classNames(classes.fileInfo, classes.fileInfoBoxTypography)}>
                                  <IconButton
                                    className={classes.deleteButton}
                                    aria-label='delete'
                                    size='small'
                                    onClick={() => {
                                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                                      if (!confirm(intl.formatMessage(messages.deleteFileConfirm))) return;

                                      form.setFieldValue(props.id, null);
                                      setUploadedFile(null);
                                    }}
                                  >
                                    <Box className={classes.fileInfo}>
                                      <DeleteIcon />
                                    </Box>
                                  </IconButton>
                                </Typography>
                              </Grid>
                            </React.Fragment>
                          )}
                        </Grid>
                      )}

                      {!value && ready && (
                        <Typography variant='h6' className={classNames(classes.fileInfo, classes.fileInfoBoxTypography)} color='textSecondary'>
                          <DiverstFormattedMessage {...messages.nofile} />
                        </Typography>
                      )}
                    </Box>
                  )}
                </Grid>
              </Grid>
              {props.showHelperText && (
                <FormHelperText
                  id={`${props.id}-helper-text`}
                  disabled={disabled || !ready}
                  error={error}
                  required={required}
                  variant={variant}
                >
                  {props.helperText}
                </FormHelperText>
              )}
            </FormControl>
          </React.Fragment>
        )}
      />
    </React.Fragment>
  );
}

DiverstFileInput.propTypes = {
  id: PropTypes.string,
  name: PropTypes.string,
  multiple: PropTypes.bool,
  classes: PropTypes.object,
  form: PropTypes.object,
  label: PropTypes.node,
  value: PropTypes.any,
  helperText: PropTypes.node,
  showHelperText: PropTypes.bool,
  handleUploadBegin: PropTypes.func,
  handleUploadSuccess: PropTypes.func,
  handleUploadError: PropTypes.func,
  fileName: PropTypes.string,
  inputProps: PropTypes.object,
  intl: intlShape.isRequired,
};

export default compose(
  withStyles(styles),
  injectIntl,
  memo,
)(DiverstFileInput);
