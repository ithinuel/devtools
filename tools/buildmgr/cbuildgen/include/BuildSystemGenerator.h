/*
 * Copyright (c) 2020-2021 Arm Limited. All rights reserved.
 *
 * SPDX-License-Identifier: Apache-2.0
 */

 // BuildSystemGenerator.h
#ifndef BUILDSYSTEMGENERATOR_H
#define BUILDSYSTEMGENERATOR_H

#include "Cbuild.h"
#include "CbuildKernel.h"

#include <string>

/**
 * @brief TranslationControls struct:
 *        optimize : optimize option
 *        debug : debug option
 *        warnings : warnings option
 *        as_msc: Assembler miscellaneous options and defines
 *        cc_msc: C Compiler miscellaneous options and defines
 *        cxx_msc: C++ Compiler miscellaneous options and defines
 *        preinc: Local preincludes
 *        defines: group defines
 *        includes: group includes
*/
struct TranslationControls
{
  std::string optimize;
  std::string debug;
  std::string warnings;
  std::string asMsc;
  std::string ccMsc;
  std::string cxxMsc;
  std::set<std::string> preinc;
  std::string defines;
  std::string includes;
};

/**
 * @brief module struct:
 *        group: Group name
 *        optimize : module optimize option
 *        debug : module debug option
 *        warnings : module warnings option
 *        flags: Assembler or C or C++ Compiler miscellaneous options and defines
 *        defines: module defines
 *        undefines: module undefines
 *        includes: module include paths
 *        excludes: module exclude paths
 */
struct module
{
  std::string group;
  std::string optimize;
  std::string debug;
  std::string warnings;
  std::string flags;
  std::string defines;
  std::string undefines;
  std::string includes;
  std::string excludes;
};

/**
 * @brief cfg struct:
 *        prj: config file from project (user file)
 *        pkg: config file from package (reference file)
*/
struct cfg
{
  std::string prj;
  std::string pkg;
};

inline bool operator<(const cfg& lhs, const cfg& rhs)
{
  return lhs.prj < rhs.prj;
}

class BuildSystemGenerator {
public:
  BuildSystemGenerator(void);
  ~BuildSystemGenerator(void);

  /**
   * @brief collect build information from RTE Model results and populate containers
   * @param inputFile fully qualified string path to cprj project file
   * @param model pointer to valid RTE Model containing build information
   * @param outdir string path to output directory
   * @param intdir string path to intermediate directory
   * @return
  */
  bool Collect(const std::string& inputFile, const CbuildModel *model, const std::string& outdir, const std::string& intdir);

  /**
   * @brief generate log file with packages, components and config files information
   * @return true if audit file is created successfully, otherwise false
  */
  bool GenAuditFile(void);

  std::string m_projectDir;
  std::string m_genfile;
  std::string m_workingDir;

protected:
  std::map<std::string, module> m_asLegacyFilesList;
  std::map<std::string, module> m_asArmclangFilesList;
  std::map<std::string, module> m_asGnuFilesList;
  std::map<std::string, module> m_asFilesList;
  std::map<std::string, module> m_ccFilesList;
  std::map<std::string, module> m_cxxFilesList;
  std::map<std::string, TranslationControls> m_groupsList;
  std::vector<std::string> m_incPathsList;
  std::vector<std::string> m_libFilesList;
  std::vector<std::string> m_definesList;
  std::vector<std::string> m_preincGlobal;
  std::set<cfg> m_cfgFilesList;
  std::string m_targetName;
  std::string m_projectName;
  std::string m_outdir;
  std::string m_intdir;
  std::string m_targetCpu;
  std::string m_targetFpu;
  std::string m_targetDsp;
  std::string m_targetTz;
  std::string m_targetSecure;
  std::string m_targetMve;
  std::string m_byteOrder;
  std::string m_outputType;
  std::string m_optimize;
  std::string m_debug;
  std::string m_warnings;
  std::string m_ccMscGlobal;
  std::string m_cxxMscGlobal;
  std::string m_asMscGlobal;
  std::string m_linkerMscGlobal;
  std::string m_linkerScript;
  std::string m_toolchain;
  std::string m_toolchainConfig;
  std::string m_auditData;
  bool m_asTargetAsm = false;

  std::string StrNorm(std::string path);
  std::string StrConv(std::string path);
  template<typename T> std::string GetString(T data);
  bool CompareFile(const std::string& filename, std::stringstream& buffer) const;
  void CollectGroupDefinesIncludes(
    const std::map<std::string, std::vector<std::string>>& defines,
    const std::map<std::string, std::vector<std::string>>& includes, const std::string& group);
  void CollectFileDefinesIncludes(
    const std::map<std::string, std::vector<std::string>>& defines,
    const std::map<std::string, std::vector<std::string>>& includes,
    std::string& src, const std::string& group, std::map<std::string, module>& FilesList);
};

#endif  // BUILDSYSTEMGENERATOR_H
